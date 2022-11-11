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

# tfdoc:file:description hprod spoke VPC and related resources.


module "hprod-spoke-vpc" {
  source             = "./modules/net-vpc"
  project_id         = module.project_network_spoke_hprod.project_id
  name               = "hprod-spoke-0"
  mtu                = 1500
  data_folder        = "${var.data_dir_network}/subnets/hprod"
  psa_config         = try(var.psa_ranges.hprod, null)
  subnets_proxy_only = local.l7ilb_subnets.hprod
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

module "hprod-spoke-firewall" {
  source              = "./modules/net-vpc-firewall"
  project_id          = module.project_network_spoke_hprod.project_id
  network             = module.hprod-spoke-vpc.name
  admin_ranges        = []
  http_source_ranges  = []
  https_source_ranges = []
  ssh_source_ranges   = []
  data_folder         = "${var.data_dir_network}/firewall-rules/hprod"
  cidr_template_file  = "${var.data_dir_network}/cidrs.yaml"
}

resource "google_compute_router" "hprod-uw2-router" {
  name    = "landing-router"
  network = module.hprod-spoke-vpc.name
  project = module.project_network_spoke_hprod.project_id
  region  = "us-west2"
  bgp {
    asn               = 4200001025
    advertise_mode    = "DEFAULT"
  }
}

module "hprod-uw2-nat" {
  source         = "./modules/net-cloudnat"
  project_id     = module.project_network_spoke_hprod.project_id
  region         = "us-west2"
  name           = "uw2"
  router_create  = false
  router_name    = google_compute_router.hprod-uw2-router.name
}


module "hprod-to-landing-uw2-vpn" {
  source     = "./modules/net-vpn-ha"
  project_id = module.project_network_spoke_hprod.project_id
  network    = module.hprod-spoke-vpc.name
  region     = "us-west2"
  name       = "vpn-to-landing-uw2"
 
  router_create    = false
  router_name      = google_compute_router.hprod-uw2-router.name
  router_asn       = google_compute_router.hprod-uw2-router.bgp[0].asn
  peer_gcp_gateway = module.landing-to-hprod-uw2-vpn.self_link
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.3.2"
        asn     = google_compute_router.landing-uw2-router.bgp[0].asn
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.3.1/30"
      ike_version                     = 2
      peer_external_gateway_interface = null
      router                          = null
      shared_secret                   = "cettrestreslesecretoulalacoupdetat"
      vpn_gateway_interface           = 0
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.4.2"
        asn     = google_compute_router.landing-uw2-router.bgp[0].asn
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.4.1/30"
      ike_version                     = 2
      peer_external_gateway_interface = null
      router                          = null
      shared_secret                   = "cettrestreslesecretoulalacoupdetat"
      vpn_gateway_interface           = 1
    }

  }
  depends_on = [
    google_compute_router.hprod-uw2-router
  ]
}