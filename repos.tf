locals {
  repositories = {
    "github-as-code" = {
      description            = "Declarative GitHub repository & governance management using OpenTofu and GitHub Actions."
      visibility             = "public"
      archived               = false
      topics                 = ["devops", "github-actions", "gitops", "infrastructure-as-code", "opentofu", "platform-engineering", "terraform"]
      has_issues             = true
      has_wiki               = false
      has_projects           = false
      has_discussions        = false
      delete_branch_on_merge = true
      protection_tier        = "pr-required"
    }

    "aljazkovac" = {
      description            = "GitHub profile README"
      visibility             = "public"
      archived               = false
      topics                 = []
      has_issues             = true
      has_wiki               = false
      has_projects           = false
      has_discussions        = false
      delete_branch_on_merge = true
      protection_tier        = "direct-push"
    }

    "aljazkovac.github.io" = {
      description            = "Personal engineering blog and website."
      visibility             = "public"
      archived               = false
      topics                 = ["blog", "devops", "jekyll", "platform-engineering", "tech-leadership"]
      has_issues             = true
      has_wiki               = false
      has_projects           = false
      has_discussions        = false
      delete_branch_on_merge = true
      protection_tier        = "direct-push"
    }

    "eat-and-burn" = {
      description            = "Personal training, health, and calorie tracker."
      visibility             = "public"
      archived               = false
      topics                 = ["ai-agents", "fastapi", "google-health", "health-tech", "python"]
      has_issues             = true
      has_wiki               = false
      has_projects           = false
      has_discussions        = false
      delete_branch_on_merge = true
      protection_tier        = "pr-required"
    }

    "calorie-balance" = {
      description            = "Personal Android app: photo food → AI calories/macros → daily balance vs. calories burned"
      visibility             = "public"
      archived               = false
      topics                 = ["android", "claude-api", "fastapi", "kotlin", "nutrition", "python"]
      has_issues             = true
      has_wiki               = false
      has_projects           = false
      has_discussions        = false
      delete_branch_on_merge = true
      protection_tier        = "pr-required"
    }

    "cockpit" = {
      description            = "Personal cockpit: goals, roadmaps, product backlogs, and writing drafts."
      visibility             = "private"
      archived               = false
      topics                 = []
      has_issues             = true
      has_wiki               = false
      has_projects           = false
      has_discussions        = false
      delete_branch_on_merge = true
      protection_tier        = "none"
    }

    "playground" = {
      description            = "Small AI, cloud, and programming experiments."
      visibility             = "private"
      archived               = false
      topics                 = []
      has_issues             = true
      has_wiki               = false
      has_projects           = false
      has_discussions        = false
      delete_branch_on_merge = true
      protection_tier        = "none"
    }

    "pulse-pipeline" = {
      description            = "A personal health data platform"
      visibility             = "public"
      archived               = false
      topics                 = []
      has_issues             = true
      has_wiki               = false
      has_projects           = false
      has_discussions        = false
      delete_branch_on_merge = true
      protection_tier        = "pr-required"
    }
  }
}

resource "github_repository" "repos" {
  for_each = local.repositories

  name        = each.key
  description = each.value.description
  visibility  = each.value.visibility
  archived    = each.value.archived
  topics      = each.value.topics

  has_issues      = each.value.has_issues
  has_wiki        = each.value.has_wiki
  has_projects    = each.value.has_projects
  has_discussions = each.value.has_discussions

  allow_merge_commit     = true
  allow_squash_merge     = true
  allow_rebase_merge     = true
  delete_branch_on_merge = each.value.delete_branch_on_merge

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [template]
  }
}
