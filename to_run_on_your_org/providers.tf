
provider "google" {

  impersonate_service_account = "terraform-sa@hackathon-admin-367612.iam.gserviceaccount.com"
  version                     = "4.40.0"

}

provider "google-beta" {

  impersonate_service_account = "terraform-sa@hackathon-admin-367612.iam.gserviceaccount.com"
  version                     = "4.40.0"
}



