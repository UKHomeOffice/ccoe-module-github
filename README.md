# CCoE Module - GitHub
This Terraform module allows you to manage your GitHub configuration in code.

It supports the creation of:
- Repositories
- Branch protection rules
- Actions permissions
- Teams
- Teams permissions
- Environments
- Issue Labels

By using this module you ensure that:
- All repos are built to a standard pattern
- Repos are always delegated to teams
- Branch protection rules are configured in a standardised way
- GitHub actions permissions are configured to a baseline

## Example Usage

The module can be called from your Terraform as shown in this example below:

```hcl
module "example" {
  source = "github.com/UKHomeOffice/ccoe-module-github?ref=v1.3.4"

  # ---------------------------------------------------------
  # Defaults
  # ---------------------------------------------------------

  # Overriding the default to allow verified GitHub actions in repos
  default_actions_verified_allowed = true

  # Adding custom google-github-actions/* alongside standard defaults (this variable is optional)
  default_actions_allowed_patterns = ["aws-actions/*", "azure/*", "hashicorp/*", "google-github-actions/*"]

  # ---------------------------------------------------------
  # Repositories
  # ---------------------------------------------------------

  repositories = {
    "public-cloud-github" = {
      name               = "public-cloud-github"
      description        = "Terraform management of the Public Cloud GitHub config."
      protected_branches = {
        "main" = {
          pattern = "main"
          checks  = ["Terraform"]
        }
      }
    }
    "ccoe-module-github" = {
      name        = "ccoe-module-github"
      description = "Module for managing GitHub config in code."
      visibility  = "public"
      protected_branches = {
        "main" = {
          pattern = "main"
        }
      }
    }
    "ccoe-prototype-2" = {
      name        = "ccoe-prototype-2"
      description = "This prototype is based on the layout of the GOV.UK Design System pages and using the Design System components - this version of our prototype has a different navigation"
      archived    = true
    }
    "ccoe" = {
      name            = "ccoe"
      description     = "Cloud Centre of Excellence (CCoE) site."
      url             = "https://ccoe.homeoffice.gov.uk"
      has_projects    = true
      allowed_actions = ["cypress-io/*"]
      protected_branches = {
        "main" = {
          pattern   = "main"
          read_only = true
        }
      }
      environments = {
        blue = {
          name = "blue"
          reviewers = {
            teams = ["Admin"]
          }
        }
        green = {
          name = "green"
          reviewers = {
            teams = ["Admin"]
          }
        }
      }
      issue_labels = {
        "Content" = {
          name  = "Content"
          color = "FF0000"
        }
      }
    }
  }

  # ---------------------------------------------------------
  # Teams
  # ---------------------------------------------------------

  teams = {
    "Admin" = {
      name        = "Admin"
      description = "Admin Team"
      permission  = "admin"
      members     = {
        "MikeHosker-HO" = {
          role = "maintainer"
        }
      }
    }
    "DevOps" = {
      name        = "DevOps"
      description = "DevOps Team"
      permission  = "push"
      members     = {
        "MikeHosker-HO" = {
          role = "maintainer"
        }
        "mhosker" = {
          role = "member"
        }
      }
    }
  }
}
```
