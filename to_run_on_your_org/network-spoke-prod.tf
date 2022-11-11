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

# tfdoc:file:description Production spoke VPC and related resources.


module "prod-spoke-vpc" { 
  source             = "./modules/net-vpc"
  project_id         = module.project_network_spoke_prod.project_id
  name               = "prod-spoke-0"
  mtu                = 1500
  data_folder        = "${var.data_dir_network}/subnets/prod"
  psa_config         = try(var.psa_ranges.prod, null)
  subnets_proxy_only = local.l7ilb_subnets.prod
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

module "prod-spoke-firewall" {
  source              = "./modules/net-vpc-firewall"
  project_id          = module.project_network_spoke_prod.project_id
  network             = module.prod-spoke-vpc.name
  admin_ranges        = []
  http_source_ranges  = []
  https_source_ranges = []
  ssh_source_ranges   = []
  data_folder         = "${var.data_dir_network}/firewall-rules/prod"
  cidr_template_file  = "${var.data_dir_network}/cidrs.yaml"
}

resource "google_compute_router" "prod-uw2-router" {
  name    = "landing-router"
  network = module.prod-spoke-vpc.name
  project = module.project_network_spoke_prod.project_id
  region  = "us-west2"
  bgp {
    asn               = 4200001026
    advertise_mode    = "DEFAULT"
  }
}

module "prod-uw2-nat" {
  source         = "./modules/net-cloudnat"
  project_id     = module.project_network_spoke_prod.project_id
  region         = "us-west2"
  name           = "uw2"
  router_create  = false
  router_name    = google_compute_router.prod-uw2-router.name
}


module "dev-to-landing-uw2-vpn" {
  source     = "./modules/net-vpn-ha"
  project_id = module.project_network_hub.project_id
  network    = module.project_network_spoke_prod.project_id
  region     = "us-west2"
  name       = "vpn-to-landing-uw2"
  # The router used for this VPN is managed in vpn-prod.tf
  router_create    = false
  router_name      = google_compute_router.prod-uw2-router.name
  router_asn       = google_compute_router.prod-uw2-router.bgp.asn
  peer_gcp_gateway = module.landing-to-dev-uw2-vpn.self_link
  tunnels = {
  }
  depends_on = [
    module.landing-to-prod-ew1-vpn.router
  ]
}

