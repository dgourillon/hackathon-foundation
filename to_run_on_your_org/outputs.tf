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

output "dev-apps-projects" {
  description = "Created dev apps projects "
  value       = module.dev-projects.project_id
}

output "prod-apps-projects" {
  description = "Created prod apps projects "
  value       = module.prod-projects.project_id
}

output "migrate-projects" {
  description = "Created M4C project"
  value       = module.project_migrate.project_id
}
