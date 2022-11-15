terraform {
  backend "gcs" {
    bucket = "mre-hackathon-tfstates"
    prefix = "hck-${var.hackathon_number}-"
  }
}