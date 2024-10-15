# *********************************************************
# OUTPUTS
# *********************************************************

# ---------------------------------------------------------
# Variables
# ---------------------------------------------------------

output "var_repositories" {
  value = var.repositories
}

output "var_teams" {
  value = var.teams
}

# ---------------------------------------------------------
# Resources
# ---------------------------------------------------------

output "repositories" {
  value = github_repository.repo
}

output "teams" {
  value = github_team.team
}