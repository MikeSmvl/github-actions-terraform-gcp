terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "~> 4.19.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region = var.project_region
}