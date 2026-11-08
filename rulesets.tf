locals {
  protected_repos = {
    for name, cfg in local.repositories :
    name => cfg
    if cfg.visibility == "public" && !cfg.archived && cfg.protection_tier != "none"
  }
}

resource "github_repository_ruleset" "default_branch" {
  for_each = local.protected_repos

  name        = "default-branch-protection"
  repository  = github_repository.repos[each.key].name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  # Repository Admin (actor_id = 5) can bypass when needed (e.g. automated workflows or urgent solo hotfixes)
  bypass_actors {
    actor_id    = 5
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }

  rules {
    deletion                = true
    non_fast_forward        = true
    required_linear_history = each.value.protection_tier == "pr-required"

    dynamic "pull_request" {
      for_each = each.value.protection_tier == "pr-required" ? [1] : []
      content {
        required_approving_review_count   = 0
        dismiss_stale_reviews_on_push     = true
        require_code_owner_review         = false
        require_last_push_approval        = false
        required_review_thread_resolution = true
      }
    }
  }
}

