provider "google" {
  region  = local.settings.region
  project = local.settings.project.id
}
provider "google-beta" {
  region  = local.settings.region
  project = local.settings.project.id
}

