##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "Public certificates secrets manager secret resource ID"
  value       = ibm_sm_public_certificate.secrets_manager_public_certificate.id
}

output "secret_id" {
  description = "Public certificates secrets manager secret unique ID"
  value       = ibm_sm_public_certificate.secrets_manager_public_certificate.secret_id
}

output "secret_crn" {
  description = "Public certificates secrets manager secret CRN"
  value       = ibm_sm_public_certificate.secrets_manager_public_certificate.crn
}
