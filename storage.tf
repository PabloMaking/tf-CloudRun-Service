resource "google_storage_bucket" "logs" {
  project                     = local.settings.project.id
  name                        = local.settings.log_bucket
  storage_class               = "REGIONAL"
  force_destroy               = true
  location                    = local.settings.region
  uniform_bucket_level_access = true
}
