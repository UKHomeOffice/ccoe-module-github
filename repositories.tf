# *********************************************************
# REPOSITORIES
# *********************************************************

# ---------------------------------------------------------
# Create Repositories
# ---------------------------------------------------------

resource "github_repository" "repo" {
  for_each = var.repositories

  name        = each.value.name
  description = each.value.description
  visibility  = each.value.visibility
  archived    = each.value.archived

  delete_branch_on_merge = true

  has_downloads = false
  has_issues    = true
  has_projects  = false
  has_wiki      = false

  vulnerability_alerts = true

  archive_on_destroy = true
}

# ---------------------------------------------------------
# Attach Repositories To Teams
# ---------------------------------------------------------

resource "github_team_repository" "team-repo" {
  for_each = merge([for tkey, tval in var.teams : { for rkey, rval in var.repositories : "${tkey}-${rkey}" => { team = tkey, repo = rkey, permission = tval.permission } }]...)

  team_id    = github_team.team[each.value.team].id
  repository = github_repository.repo[each.value.repo].name
  permission = each.value.permission
}

# ---------------------------------------------------------
# Branch Protection
# ---------------------------------------------------------

resource "github_branch_protection" "branch-protection" {
  for_each = merge([for rkey, rval in var.repositories : { for pbkey, pbvalue in rval.protected_branches : "${rkey}-${pbkey}" => merge(pbvalue, { repo = rkey }) }]...)

  repository_id = github_repository.repo[each.value.repo].node_id

  pattern                         = each.value.pattern
  enforce_admins                  = true
  required_linear_history         = true
  require_conversation_resolution = true
  require_signed_commits          = true
  allows_deletions                = true
  allows_force_pushes             = false

  required_status_checks {
    strict   = true
    contexts = each.value.checks
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = each.value.required_approving_review_count
    require_code_owner_reviews      = each.value.require_code_owner_reviews
  }
}

# ---------------------------------------------------------
# Allowed Actions
# ---------------------------------------------------------

resource "github_actions_repository_permissions" "allowed-actions" {
  for_each = var.repositories

  repository = github_repository.repo[each.key].name

  allowed_actions = "selected"
  enabled         = true

  allowed_actions_config {
    github_owned_allowed = true
    verified_allowed     = false
    patterns_allowed = concat([
      "aws-actions/*",
      "azure/*",
      "hashicorp/*",
    ], each.value.allowed_actions)
  }
}