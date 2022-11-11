
provider "google" {

  impersonate_service_account = " terraform-sa@hackathon-admin-367612.iam.gserviceaccount.com"

}

provider "google-beta" {

  impersonate_service_account = " terraform-sa@hackathon-admin-367612.iam.gserviceaccount.com"

}



