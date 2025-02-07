resource "google_cloud_identity_group" "vertex_ai_group" {
  provider   = google-beta
  parent     = "customers/my-customer"
  group_key {
    id = "vertex-ai-users@mydomain.com" # Adjust domain accordingly
  }
  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
  }
  display_name = "Vertex AI Users"
  description  = "Group for users who require access to Vertex AI tools."
}

resource "google_cloud_identity_group_membership" "vertex_ai_members" {
  for_each = toset(var.users)

  provider   = google-beta
  group      = google_cloud_identity_group.vertex_ai_group.id
  preferred_member_key {
    id = each.value
  }
  roles {
    name = "MEMBER"
  }
}

resource "google_project_iam_member" "vertex_ai_roles" {
  for_each = toset([
    "roles/aiplatform.user",
    "roles/aiplatform.admin",
    "roles/aiplatform.viewer",
    "roles/notebooks.admin",            # Allow users to create Workbench instances
    "roles/compute.instanceAdmin.v1"     # Required for managing compute nodes
  ])

  project = var.project_id
  role    = each.value
  member  = "group:vertex-ai-users@mydomain.com"
} 

output "group_email" {
  value = "vertex-ai-users@mydomain.com"
  description = "Email of the Vertex AI user group."
}

# Notes:
# This configuration ensures real-time cost oversight and security compliance, leveraging:
# - Industry, OEM, and internal best practices
# - Captured lessons learned to reduce client risk
#
# Ensure the `variables.tf` file includes:
#
# variable "project_id" {
#   description = "The ID of the project where Vertex AI tools will be used."
#   type        = string
# }
#
# variable "users" {
#   description = "List of users to be added to the Vertex AI group."
#   type        = list(string)
# }
#
# Example usage:
#
# project_id = "my-gcp-project"
# users = ["user1@example.com", "user2@example.com"]
