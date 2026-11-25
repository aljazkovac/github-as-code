locals {
  existing_repositories = toset([
    "github-as-code",
    "aljazkovac",
    "aljazkovac.github.io",
    "eat-and-burn",
    "calorie-balance",
    "playground",
  ])
}

import {
  for_each = local.existing_repositories
  to       = github_repository.repos[each.key]
  id       = each.key
}
