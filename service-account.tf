resource "google_service_account" "cloudbuild_service_account" {
  account_id = local.settings.sa_id
}
