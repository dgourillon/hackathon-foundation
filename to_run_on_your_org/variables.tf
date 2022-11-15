/**
 * Copyright 2018 Google LLC
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

variable "parent_id" {
  type        = string
  description = "Id of the resource under which the folder will be placed."
}

variable "hackathon_folder_name" {
  type        = string
  description = "top folder for the hackathon"
}

variable "hackathon_number" {
  type        = string
  description = "hackathon number"
}

variable "hackathon_migration_team_email" {
  type        = string
  description = "Email of the Hackathon migration team."

}

variable "hackathon_migration_team_email" {
  type        = string
  description = "Email of the Hackathon admin team."

}

variable "parent_type" {
  type        = string
  description = "Type of the parent resource. One of `organizations` or `folders`."
  default     = "folders"
}

variable "billing_account" {
  type        = string
  description = "billing account to use for projects"
}

variable "names" {
  type        = list(string)
  description = "Folder names."
  default     = []
}

variable "per_folder_admins" {
  type        = map(string)
  description = "IAM-style members per folder who will get extended permissions."
  default     = {}
}

variable "all_folder_admins" {
  type        = list(string)
  description = "List of IAM-style members that will get the extended permissions across all the folders."
  default     = []
}
variable "mtb_project" {
  type        = string
  description = "billing account to use for projects"
  default     = "mtb_project_id_default_value"
}

variable "mtb_network" {
  type        = string
  description = "billing account to use for projects"
  default     = "migrate-network"
}

variable "data_dir" {
  description = "Relative path for the folder storing configuration data for network resources."
  type        = string
  default     = "data"
}

variable "data_dir_network" {
  description = "Relative path for the folder storing configuration data for network resources."
  type        = string
  default     = "data-network"
}

variable "data_dir_projects" {
  description = "Relative path for the folder storing configuration data for network resources."
  type        = string
  default     = "data-projects"
}


variable "defaults_file" {
  description = "Relative path for the file storing the project factory configuration."
  type        = string
  default     = "data/defaults.yaml"
}



variable "defaults_file_projects" {
  description = "Relative path for the file storing the project factory configuration."
  type        = string
  default     = "data-projects/defaults.yaml"
}



variable "region_trigram" {
  description = "Short names for GCP regions."
  type        = map(string)
  default = {
    europe-west1 = "ew1"
    europe-west3 = "ew3"
    us-central1 = "uc1"
    us-west2 = "uw2"
  }
}

variable "psa_ranges" {
  description = "IP ranges used for Private Service Access (e.g. CloudSQL)."
  type = object({
    dev = object({
      ranges = map(string)
      routes = object({
        export = bool
        import = bool
      })
    })
    prod = object({
      ranges = map(string)
      routes = object({
        export = bool
        import = bool
      })
    })
  })
  default = null
  # default = {
  #   dev = {
  #     ranges = {
  #       cloudsql-mysql     = "10.128.62.0/24"
  #       cloudsql-sqlserver = "10.128.63.0/24"
  #     }
  #     routes = null
  #   }
  #   prod = {
  #     ranges = {
  #       cloudsql-mysql     = "10.128.94.0/24"
  #       cloudsql-sqlserver = "10.128.95.0/24"
  #     }
  #     routes = null
  #   }
  # }
}

variable "l7ilb_subnets" {
  description = "Subnets used for L7 ILBs."
  type = map(list(object({
    ip_cidr_range = string
    region        = string
  })))
  default = {
    prod = [
      { ip_cidr_range = "10.128.92.0/24", region = "europe-west1" },
      { ip_cidr_range = "10.128.93.0/24", region = "europe-west4" }
    ]
    nonprod = [
      { ip_cidr_range = "10.128.60.0/24", region = "europe-west1" },
      { ip_cidr_range = "10.128.61.0/24", region = "europe-west4" }
    ]
  }
}

variable "environment_dns_zone" {
  # tfdoc:variable:source 02-networking
  description = "DNS zone suffix for environment."
  type        = string
  default     = null
}
