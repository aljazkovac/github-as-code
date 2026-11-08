output "managed_repositories" {
  description = "Summary of managed GitHub repositories and their branch protection tiers."
  value = {
    for name, repo in github_repository.repos :
    name => {
      visibility      = repo.visibility
      protection_tier = local.repositories[name].protection_tier
      html_url        = repo.html_url
    }
  }
}
