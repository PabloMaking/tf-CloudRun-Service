locals {
  workspace_file = "./settings/${terraform.workspace}.yaml"
  defaults       = file("./settings/default.yaml")
  workspace_data = fileexists(local.workspace_file) ? file(local.workspace_file) : yamlencode({})
  settings = merge(
    yamldecode(local.defaults),
    yamldecode(local.workspace_data)
  )

  repo_url   = "europe-west1-docker.pkg.dev/aie-sandbox--pct--ac/${local.settings.repo_name}"
  image_name = "build-tf"
}
