


module "top_folder" {
  source = "./modules/folder"
  parent            = "${var.parent_type}/${var.parent_id}"
  name   = "hackaton-1"
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
  source = "./modules/folder"
  parent            = module.top_folder.id
  name   = "network"
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
  folder_create = var.folder_ids.networking == null
  id            = var.folder_ids.networking
  firewall_policy_factory = {
    cidr_file   = "${var.data_dir}/cidrs.yaml"
    policy_name = null
    rules_file  = "${var.data_dir}/hierarchical-policy-rules.yaml"
  }
  firewall_policy_association = {
    factory-policy = "factory"
  }
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

