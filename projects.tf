# *********************************************************
# PROJECTS
# *********************************************************

# ---------------------------------------------------------
# Create Projects
# ---------------------------------------------------------

resource "github_organization_project" "project" {
  for_each = var.projects

  name       = each.value.name
  body       = each.value.body
}

# ---------------------------------------------------------
# Create Columns
# ---------------------------------------------------------

resource "github_project_column" "column" {
  for_each = merge([ for pkey, pval in var.projects : { for ckey, cvalue in pval.columns : "${pkey}-${ckey}" => merge(cvalue, { project = pkey }) }]...)

  project_id = github_organization_project.project[each.value.project].id
  name       = each.value.name
}