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
  project_id          = module.project_network_hub.project_id
  network             = module.landing-vpc.name
  admin_ranges        = []
  http_source_ranges  = []
  https_source_ranges = []
  ssh_source_ranges   = []
  data_folder         = "${var.data_dir}/firewall-rules/landing"
  cidr_template_file  = "${var.data_dir}/cidrs.yaml"
}

resource "google_compute_router" "landing-uw2-router" {
  name    = "landing-router"
  project = module.project_network_hub.project_id
  network = module.landing-vpc.name
  region  = "us-west2"
  bgp {
    asn               = 4200001024
    advertise_mode    = "DEFAULT"
  }
}

module "landing-uw2-nat" {
  source         = "./modules/net-cloudnat"
  project_id     = module.project_network_hub.project_id
  region         = "us-west2"
  name           = "uw2"
  router_create  = false
  router_name    = google_compute_router.landing-uw2-router.name
}


module "landing-to-dev-uw2-vpn" {
  source     = "./modules/net-vpn-ha"
  project_id = module.project_network_hub.project_id
  network    = module.landing-vpc.name
  region     = "us-west2"
  name       = "vpn-to-dev-uw2"
  # The router used for this VPN is managed in vpn-prod.tf
  router_create    = false
  router_name      = google_compute_router.landing-uw2-router.name
  router_asn       = google_compute_router.landing-uw2-router.bgp.asn
  peer_gcp_gateway = module.dev-to-landing-uw2-vpn.self_link
  tunnels = {
    
  }
  depends_on = [
    google_compute_router.landing-uw2-router
  ]
}