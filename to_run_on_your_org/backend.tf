terraform {
  backend "gcs" {
    bucket = "mre-hackathon-tfstates"
    prefix = "hck-UPDATE_ME_WITH_HACKATHON_NUMBER"
  }
}