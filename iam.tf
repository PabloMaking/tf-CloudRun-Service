# resource "google_project_iam_member" "act_as" {
#   project = local.settings.project.id
#   role    = "roles/artifactregistry.writer"
#   member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
# }

# resource "google_project_iam_member" "storage" {
#   project = local.settings.project.id
#   role    = "roles/storage.objectAdmin"
#   member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
# }

# resource "google_project_iam_member" "build" {
#   project = local.settings.project.id
#   role    = "roles/cloudbuild.builds.builder"
#   member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
# }

# resource "google_project_iam_member" "deploy" {
#   project = local.settings.project.id
#   role    = "roles/run.admin"
#   member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
# }

# resource "google_project_iam_member" "deploy-iam" {
#   project = local.settings.project.id
#   role    = "roles/iam.serviceAccountUser"
#   member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
# }

# resource "google_storage_bucket_iam_member" "member" {
#   bucket = google_storage_bucket.logs.name
#   role   = "roles/storage.admin"
#   member = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
# }

module "iam_member_permission" {
  source     = "git::ssh://git@bitbucket.org/i2tic/tf_gcp_project_iam_permissions.git?ref=v1.8-202311291545"
  project_id = local.settings.project.id
  permissions = [
    {
      members = [format("serviceAccount:%s", google_service_account.cloudbuild_service_account.email)]
      roles = [
        "roles/cloudkms.cryptoKeyEncrypterDecrypter",
        "roles/storage.objectAdmin",
        "roles/cloudbuild.builds.builder",
        "roles/run.admin",
        "roles/iam.serviceAccountUser",
        "roles/storage.admin",
        # "roles/artifactregistry.admin",
      ]
    }
  ]
}

#artifactregistry.repositories.setIamPolicy
