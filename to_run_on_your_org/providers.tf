provider "google" {
  
  alias   = "tokengen"
}
data "google_client_config" "default" {
  provider = "google.tokengen"
}
data "google_service_account_access_token" "sa" {
  provider               = "google.tokengen"
  target_service_account = "terraform-sa@hackathon-admin-367612.iam.gserviceaccount.com"
  lifetime               = "600s"
scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}
/******************************************
  GA Provider configuration
 *****************************************/
provider "google" {
  
  access_token = data.google_service_account_access_token.sa.access_token

}
/******************************************
  Beta Provider configuration
 *****************************************/
provider "google-beta" {
  
  access_token = data.google_service_account_access_token.sa.access_token

}
