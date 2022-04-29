# create bucket
resource "google_storage_bucket" "bucket" {
  name     = "test-bucket-1230"
  location = var.project_region
}

# Compress source code
locals {
  timestamp = formatdate("YYMMDDhhmmss", timestamp())
}
data "archive_file" "source" {
  type        = "zip"
  source_dir  = abspath("../")
  output_path = "/tmp/function-${local.timestamp}.zip"
}

# Add source code zip to bucket
resource "google_storage_bucket_object" "zip" {
  # Append file MD5 to force bucket to be recreated
  name   = "source.zip#${data.archive_file.source.output_md5}"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.source.output_path
}

# create service account
resource "google_service_account" "service_account" {
  account_id = "test-service-account"
}

resource "google_project_iam_member" "service_account_binding" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

# create function
resource "google_cloudfunctions_function" "function" {
  name                  = "test-function"
  runtime               = "nodejs16"
  ingress_settings      = "ALLOW_ALL"
  service_account_email = google_service_account.service_account.email

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.zip.name
  trigger_http          = true
  entry_point           = "app"
}


# makes accessible to everyone
resource "google_cloudfunctions_function_iam_binding" "binding" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name
  role           = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}