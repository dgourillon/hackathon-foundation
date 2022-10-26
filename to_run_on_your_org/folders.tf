


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

