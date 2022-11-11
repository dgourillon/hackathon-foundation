


module "top_folder" {
  source = "./modules/folder"
  parent            = "${var.parent_type}/${var.parent_id}"
  name   = var.hackathon_folder_name
  group_iam = {
  }
  iam = {
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

