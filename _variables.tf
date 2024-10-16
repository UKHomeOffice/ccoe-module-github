# *********************************************************
# VARIABLES
# *********************************************************

# ---------------------------------------------------------
# Repositories
# ---------------------------------------------------------

variable "repositories" {
  type = map(object({
    name        = string
    description = string
    visibility  = optional(string, "internal")
    archived    = optional(bool, false)
    protected_branches = optional(map(object({
      pattern                         = string
      checks                          = optional(list(string), [])
      required_approving_review_count = optional(number, 0)
      require_code_owner_reviews      = optional(bool, false)
    })), {})
    environments = optional(map(object({
      name                    = string
      can_admins_bypass       = optional(bool, false)
      prevent_self_review     = optional(bool, false)
      protected_branches_only = optional(bool, true)
      custom_branch_policies  = optional(bool, false)
      reviewers               = optional(object({
        users = optional(list(string), []) # Either ID (number) OR GitHub username
        teams = optional(list(string), []) # Either ID (number) OR key from team map OR GitHub team name
      }), {})
    })), {})
    allowed_actions = optional(list(string), [])
  }))
  description = "Repositories to create."
}

# ---------------------------------------------------------
# Teams
# ---------------------------------------------------------

variable "teams" {
  type = map(object({
    name        = string
    description = string
    permission  = string
    privacy     = optional(string, "closed")
    members = map(object({
      role = optional(string, "member")
    }))
  }))
  description = "Teams to create."
}