# Notes:
# This configuration ensures real-time cost oversight and security compliance, leveraging:
# - Industry, OEM, and internal best practices
# - Captured lessons learned to reduce client risk
#
# Ensure the `variables.tf` file includes:
#
variable "project_id" {
   description = "The ID of the project where Vertex AI tools will be used."
   type        = string
 }

 variable "users" {
   description = "List of users to be added to the Vertex AI group."
   type        = list(string)
 }

# Example usage:
#
# project_id = "my-gcp-project"
# users = ["user1@example.com", "user2@example.com"]
