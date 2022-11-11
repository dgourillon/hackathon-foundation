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

# tfdoc:file:description Dev spoke VPC and related resources.


module "dev-spoke-vpc" {
  source             = "./modules/net-vpc"
  project_id         = module.project_network_spoke_dev.project_id
  name               = "dev-spoke-0"
  mtu                = 1500
  data_folder        = "${var.data_dir_network}/subnets/dev"
  psa_config         = try(var.psa_ranges.dev, null)
  subnets_proxy_only = local.l7ilb_subnets.dev
  # set explicit routes for googleapis in case the default route is deleted
  routes = {
    private-googleapis = {
      dest_range    = "199.36.153.8/30"
      next_hop_type = "gateway"
      next_hop      = "default-internet-gateway"
    }
    restricted-googleapis = {
      dest_range    = "199.36.153.4/30"
      next_hop_type = "gateway"
      next_hop      = "default-internet-gateway"
    }
  }
}

module "dev-spoke-firewall" {
  source              = "./modules/net-vpc-firewall"
  project_id          = module.project_network_spoke_dev.project_id
  network             = module.dev-spoke-vpc.name
  admin_ranges        = []
  http_source_ranges  = []
  https_source_ranges = []
  ssh_source_ranges   = []
  data_folder         = "${var.data_dir_network}/firewall-rules/dev"
  cidr_template_file  = "${var.data_dir_network}/cidrs.yaml"
}

module "dev-spoke-router" {
  for_each       = toset(values(module.dev-spoke-vpc.subnet_regions))
  source         = "./modules/net-cloudnat"
  project_id     = module.project_network_spoke_dev.project_id
  region         = each.value
  name           = "router-${var.region_trigram[each.value]}"
  router_create  = true
  router_network = module.dev-spoke-vpc.name
  router_asn     = 4200001026
  logging_filter = "ERRORS_ONLY"
}

# Create delegated grants for stage3 service accounts

