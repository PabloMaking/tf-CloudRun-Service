terraform {

  backend "gcs" {
    bucket = "aie-sandbox--pct--ac-build"
  }


  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.18.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "3.77.0"
    }

  }
}
