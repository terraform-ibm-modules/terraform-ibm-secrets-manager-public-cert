resource "ibm_sm_public_certificate" "secrets_manager_public_certificate" {
  instance_id     = var.secrets_manager_guid
  region          = var.secrets_manager_region
  endpoint_type   = var.service_endpoints
  name            = var.cert_name
  description     = var.cert_description
  ca              = var.secrets_manager_ca_name
  dns             = var.secrets_manager_dns_provider_name
  common_name     = var.cert_common_name
  secret_group_id = var.cert_secrets_group_id
  alt_names       = var.cert_alt_names
  bundle_certs    = var.bundle_certs
  key_algorithm   = var.key_algorithm
  rotation {
    auto_rotate = var.cert_rotation.auto_rotate
    rotate_keys = var.cert_rotation.rotate_keys
  }
}
