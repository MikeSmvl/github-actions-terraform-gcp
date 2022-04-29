variable "project_id" {
  type        = string
  description = "The Google Cloud project id"
  default = "test-atlantis-348621"
}

variable "project_region" {
  type = string
  description = "The Google Cloud project region"
  default = "us-west1"
}

variable "bucket_name" {
  type = string
  description = "The Google Cloud bucket name"
  default = "test-bucket-cloudfunction"
}

variable "function_name" {
  type = string
  description = "The Google Cloud function name"
  default = "test-function"
}

variable "function_entry_point" {
  type = string
  description = "The Google Cloud function entrypoint"
  default = "app"
}