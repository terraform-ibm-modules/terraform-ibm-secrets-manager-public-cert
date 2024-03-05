##############################################################################
# Outputs
##############################################################################

output "secret_id" {
  description = "Public certificates secrets manager secret ID"
  value       = module.secrets_manager_public_certificate.secret_id
  sensitive   = false
}
