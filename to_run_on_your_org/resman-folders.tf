


module "top_folder" {
  source = "./modules/folder"
  parent            = "${var.parent_type}/${var.parent_id}"
  name   = "hackathon-${var.hackathon_number}"
  group_iam = {
 
    "var.hackathon_migration_team_email" = [
      "roles/logging.admin",                 
      "roles/browser",
      "roles/compute.admin",
      "roles/iam.serviceAccountUser",
      "roles/iap.tunnelResourceAccessor",
      "roles/resourcemanager.folderViewer",
      "roles/vmmigration.admin"             
    ]
  }
  iam_additive = {
  }
  tag_bindings = {
  }
}

module "migrate_folder" {
  source = "./modules/folder"
  parent            = module.top_folder.id
  name   = "migrate"
  group_iam = {
  }
  iam = {
  }
  tag_bindings = {
  }
}


module "network_folder" {
  source        = "./modules/folder"
  parent        = module.top_folder.id
  name          = "network"
  firewall_policy_factory = {
    cidr_file   = "${var.data_dir}/cidrs.yaml"
    policy_name = "test"
    rules_file  = "${var.data_dir}/hierarchical-policy-rules.yaml"
  }
 # firewall_policy_association = {
 #   factory-policy = "factory"
 # }
}

module "apps_folder" {
  source = "./modules/folder"
  parent            = module.top_folder.id
  name   = "apps"
  group_iam = {
  }
  iam = {
  }
  tag_bindings = {
  }
}

