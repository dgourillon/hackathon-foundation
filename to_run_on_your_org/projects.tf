
resource "random_string" "random" {
  length           = 4
  special          = false
  upper          = false
}

module "project_migrate" {
  source              = "./modules/project"
  billing_account     = var.billing_account
  name                = "migrate-project-${random_string.random.result}"
  auto_create_network = false
  parent              = module.migrate_folder.id
  services            = [
    "compute.googleapis.com",
    "stackdriver.googleapis.com",
    "vmmigration.googleapis.com",
    "servicemanagement.googleapis.com", 
    "servicecontrol.googleapis.com" ,
    "iam.googleapis.com" ,
    "cloudresourcemanager.googleapis.com", 
    "billingbudgets.googleapis.com"
  ]

}

module "project_app_dev" {
  source              = "./modules/project"
  billing_account     = var.billing_account
  name                = "app-dev-project-${random_string.random.result}"
  auto_create_network = false
  parent              = module.apps_folder.id
  services            = [
    "compute.googleapis.com",
    "stackdriver.googleapis.com", 
    "billingbudgets.googleapis.com"
  ]

}

module "project_app_nonprod" {
  source              = "./modules/project"
  billing_account     = var.billing_account
  name                = "app-nonprod-project-${random_string.random.result}"
  auto_create_network = false
  parent              = module.apps_folder.id
  services            = [
    "compute.googleapis.com",
    "stackdriver.googleapis.com", 
    "billingbudgets.googleapis.com"
  ]

}

module "project_app_prod" {
  source              = "./modules/project"
  billing_account     = var.billing_account
  name                = "app-prod-project-${random_string.random.result}"
  auto_create_network = false
  parent              = module.apps_folder.id
  services            = [
    "compute.googleapis.com",
    "stackdriver.googleapis.com", 
    "billingbudgets.googleapis.com"
  ]

}

module "project_network_hub" {
  source              = "./modules/project"
  billing_account     = var.billing_account
  name                = "net-hub-project-${random_string.random.result}"
  auto_create_network = false
  parent              = module.network_folder.id
  services            = [
    "compute.googleapis.com",
    "dns.googleapis.com",
    "iap.googleapis.com",
    "networkmanagement.googleapis.com",
    "stackdriver.googleapis.com", 
    "billingbudgets.googleapis.com"
  ]

}

module "project_network_spoke_prod" {
  source              = "./modules/project"
  billing_account     = var.billing_account
  name                = "net-prod-project-${random_string.random.result}"
  auto_create_network = false
  parent              = module.network_folder.id
  services            = [
    "compute.googleapis.com",
    "dns.googleapis.com",
    "iap.googleapis.com",
    "networkmanagement.googleapis.com",
    "stackdriver.googleapis.com", 
    "billingbudgets.googleapis.com"
  ]

}

module "project_network_spoke_dev" {
  source              = "./modules/project"
  billing_account     = var.billing_account
  name                = "net-nonprod-project-${random_string.random.result}"
  auto_create_network = false
  parent              = module.network_folder.id
  services            = [
    "compute.googleapis.com",
    "dns.googleapis.com",
    "iap.googleapis.com",
    "networkmanagement.googleapis.com",
    "stackdriver.googleapis.com", 
    "billingbudgets.googleapis.com"
  ]

}