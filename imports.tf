locals {
  existing_repositories = toset([
    "aljazkovac",
    "aljazkovac.github.io",
    "eat-and-burn",
    "calorie-balance",
    "cockpit",
    "playground",
  ])
}

import {
  for_each = local.existing_repositories
  to       = github_repository.repos[each.key]
  id       = each.key
}
