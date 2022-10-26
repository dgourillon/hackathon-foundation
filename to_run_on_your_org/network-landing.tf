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

# tfdoc:file:description Landing VPC and related resources.


module "landing-vpc" {
  source     = "./modules/net-vpc"
  project_id = module.project_network_hub.project_id
  name       = "prod-landing-0"
  mtu        = 1500
  dns_policy = {
    inbound = true
  }
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
  data_folder = "${var.data_dir}/subnets/landing"
}

module "landing-firewall" {
  source              = "./modules/net-vpc-firewall"
  project_id          = module.landing-project.project_id
  network             = module.landing-vpc.name
  admin_ranges        = []
  http_source_ranges  = []
  https_source_ranges = []
  ssh_source_ranges   = []
  data_folder         = "${var.data_dir}/firewall-rules/landing"
  cidr_template_file  = "${var.data_dir}/cidrs.yaml"
}

module "landing-nat-ew1" {
  source         = "./modules/net-cloudnat"
  project_id     = module.landing-project.project_id
  region         = "europe-west1"
  name           = "ew1"
  router_create  = true
  router_name    = "prod-nat-ew1"
  router_network = module.landing-vpc.name
  router_asn     = 4200001024
}
