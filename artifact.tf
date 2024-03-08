#resource "google_artifact_registry_repository" "my-repo" {
#  location      = local.settings.region
#  repository_id = local.settings.repo_name
#  description   = "Repositorio para mkdocs automatization"
#  format        = "DOCKER"
#  #depends_on = [docker_image.mkdocs-tf]
#}

module "artifact_registry" {
  source = "git::ssh://git@bitbucket.org/i2tic/tf_gcp_artifactregistry.git?ref=v1.6-202311291612"

  gcp_project_id            = local.settings.project.id
  base_name                 = local.settings.repo_name
  region_name               = local.settings.region
  authoritative_permissions = true
  permissions = {
    cloudbuild_sa = {
      members = [format("serviceAccount:%s", google_service_account.cloudbuild_service_account.email)]
      roles = [
        "roles/artifactregistry.writer",
      ],
    }
  }
}
