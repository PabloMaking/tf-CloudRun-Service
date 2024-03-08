resource "google_cloudbuild_trigger" "assets-build" {
  name        = "assets-build"
  description = "Build and push Docker image for webapp to Artifact Registry"

  trigger_template {
    project_id = local.settings.project.id
    repo_name  = "mkdocs-tf"
    tag_name   = "test"
  }

  service_account = google_service_account.cloudbuild_service_account.id

  build {
    logs_bucket = google_storage_bucket.logs.name
    step {
      id   = "Build"
      name = "gcr.io/cloud-builders/docker"
      args = [
        "build",
        "--tag",
        # "${local.repo_url}/${local.image_name}",
        "${module.artifact_registry.artifact_repo_url}/${local.image_name}",
        "."
      ]
    }

    step {
      id   = "Push"
      name = "gcr.io/cloud-builders/docker:20.10.13"
      args = [
        "push",
        # "${local.repo_url}/${local.image_name}"
        "${module.artifact_registry.artifact_repo_url}/${local.image_name}"
      ]
    }

    step {
      id   = "gcloud-deploy"
      name = "gcr.io/cloud-builders/gcloud"
      args = [
        "run",
        "deploy",
        "assets-tf",
        "--image", "${module.artifact_registry.artifact_repo_url}/${local.image_name}",
        "--region", "europe-west1"
      ]

    }


    step {
      id   = "set-noauth-policy"
      name = "gcr.io/cloud-builders/gcloud"
      args = [
        "run",
        "services",
        "set-iam-policy",
        "assets-tf",
        "--platform=managed",
        "--region=europe-west1",
        "--project=aie-sandbox--pct--ac",
        "--policy=bindings:[role='roles/run.invoker',members=['allUsers']]",
      ]
    }
  }
}

resource "google_cloud_run_service" "default" {
  name     = "assets-tf"
  location = "europe-west1"

  metadata {
    namespace = "aie-sandbox--pct--ac"
  }

  template {
    spec {
      containers {
        image = "${module.artifact_registry.artifact_repo_url}/${local.image_name}"
      }
    }
  }
  depends_on = [null_resource.push]
}

resource "google_cloud_run_service_iam_member" "member" {
  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  service  = google_cloud_run_service.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "null_resource" "push" {

  provisioner "local-exec" {
    command = "docker push ${module.artifact_registry.artifact_repo_url}/${local.image_name}"
  }

  depends_on = [module.artifact_registry]
}
