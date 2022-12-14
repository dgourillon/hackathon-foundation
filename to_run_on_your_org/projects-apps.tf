/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# tfdoc:file:description Project factory.


locals {
  _defaults = yamldecode(file(var.defaults_file_projects))
  _defaults_net = {
    shared_vpc_self_link = module.landing-vpc.self_link
    vpc_host_project     = module.project_network_spoke_nonprod.project_id
    environment_dns_zone = var.environment_dns_zone
    billing_account_id   = var.billing_account

  }
  defaults = merge(local._defaults, local._defaults_net)
  dev_projects = {
    for f in fileset("${var.data_dir_projects}", "dev/*.yaml") :
    trimsuffix(f, ".yaml") => yamldecode(file("${var.data_dir_projects}/${f}"))
  }
  prod_projects = {
    for f in fileset("${var.data_dir_projects}", "prod/*.yaml") :
    trimsuffix(f, ".yaml") => yamldecode(file("${var.data_dir_projects}/${f}"))
  }
}


module "dev-projects" {
  source                 = "./factories/project-factory"
  for_each               = local.dev_projects
  defaults               = local.defaults
  project_id             = replace("${each.key}-${random_string.random.result}", "dev/", "dev-")
  billing_account_id     = var.billing_account
  billing_alert          = try(each.value.billing_alert, null)
  essential_contacts     = []
  folder_id              = module.apps_folder.id
  group_iam              = try(each.value.group_iam, {})
  iam                    = try(each.value.iam, {})
  kms_service_agents     = try(each.value.kms, {})
  labels                 = merge(try(each.value.labels, {}),{hackathon_number = var.hackathon_number})
  org_policies           = try(each.value.org_policies, null)

  service_accounts       = try(each.value.service_accounts, {})
  service_accounts_iam   = try(each.value.service_accounts_iam, {})
  services               = try(each.value.services, [])
  service_identities_iam = try(each.value.service_identities_iam, {})

}

resource "google_compute_shared_vpc_service_project" "dev-xpn-service" {
  for_each        = local.dev_projects
  host_project    = module.project_network_spoke_nonprod.project_id
  service_project = replace("${each.key}-${random_string.random.result}", "dev/", "dev-")
}

resource "google_monitoring_monitored_project" "dev-metric-scopes" {
  for_each        = local.dev_projects
  metrics_scope = module.project_monitoring.project_id
  name          = replace("${each.key}-${random_string.random.result}", "dev/", "dev-")
}

module "prod-projects" {
  source                 = "./factories/project-factory"
  for_each               = local.prod_projects
  defaults               = local.defaults
  project_id             = replace("${each.key}-${random_string.random.result}", "prod/", "prd-")
  billing_account_id     = var.billing_account
  billing_alert          = try(each.value.billing_alert, null)
  essential_contacts     = []
  folder_id              = module.apps_folder.id
  group_iam              = try(each.value.group_iam, {})
  iam                    = try(each.value.iam, {})
  kms_service_agents     = try(each.value.kms, {})
  labels                 = merge(try(each.value.labels, {}),{hackathon_number = var.hackathon_number})
  org_policies           = try(each.value.org_policies, null)
  service_accounts       = try(each.value.service_accounts, {})
  service_accounts_iam   = try(each.value.service_accounts_iam, {})
  services               = try(each.value.services, [])
  service_identities_iam = try(each.value.service_identities_iam, {})

}

resource "google_compute_shared_vpc_service_project" "prod-xpn-service" {
  for_each        = local.prod_projects
  host_project    = module.project_network_spoke_prod.project_id
  service_project = replace("${each.key}-${random_string.random.result}", "prod/", "prd-")
}

resource "google_monitoring_monitored_project" "prod-metric-scopes" {
  for_each        = local.prod_projects
  metrics_scope = module.project_monitoring.project_id
  name          = replace("${each.key}-${random_string.random.result}", "prod/", "prd-") 
}