locals {
  # Enable automated Dependabot CVE security-fix PRs on all active public repositories
  security_update_repos = {
    for name, cfg in local.repositories :
    name => cfg
    if cfg.visibility == "public" && !cfg.archived
  }
}

resource "github_repository_dependabot_security_updates" "security_updates" {
  for_each = local.security_update_repos

  repository = github_repository.repos[each.key].name
  enabled    = true
}
