##############################################################################
# Example configuration of the required resources to create a public certificate
#
# - CIS instance to own DNS records
# - Secrets Manger instance to create and store certificate
# - Secrets Manager configuration for public certificate engine
#   - Including a certificate authority (LetsEncrypt)
# - Secret Group as best practise for managing access to certificates
#
# Once the infrastructure is configured, request a certificate in the
# secret group, using the CA and DNS provider from the engine.
#

locals {
  sm_guid   = var.existing_sm_instance_guid == null ? module.secrets_manager[0].secrets_manager_guid : var.existing_sm_instance_guid
  sm_region = var.existing_sm_instance_region == null ? var.region : var.existing_sm_instance_region
  tags      = [for tag in var.resource_tags : lower(tag)]
  # generate a certificate common name by prepending the prefix to the domain
  # for validation this is random, real use would be an application FQDN
  cert_common_name = "${var.prefix}.${var.domain_name}"
}

##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.2.0"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

# Use the secret manager module to generate an instance for the public certificate
module "secrets_manager" {
  count                = var.existing_sm_instance_guid == null ? 1 : 0
  source               = "terraform-ibm-modules/secrets-manager/ibm"
  version              = "2.2.8"
  resource_group_id    = module.resource_group.resource_group_id
  region               = local.sm_region
  secrets_manager_name = "${var.prefix}-secrets-manager" #tfsec:ignore:general-secrets-no-plaintext-exposure
  allowed_network      = var.sm_allowed_network
  endpoint_type        = var.sm_endpoint_type
  sm_service_plan      = "trial"
  sm_tags              = local.tags
}

# Best practise, use the secrets manager secret group module to create a secret group
module "secrets_manager_secret_group" {
  source                   = "terraform-ibm-modules/secrets-manager-secret-group/ibm"
  version                  = "1.3.5"
  region                   = local.sm_region
  secrets_manager_guid     = local.sm_guid
  secret_group_name        = "${var.prefix}-certificates-secret-group"   #checkov:skip=CKV_SECRET_6: does not require high entropy string as is static value
  secret_group_description = "secret group used for public certificates" #tfsec:ignore:general-secrets-no-plaintext-exposure
  endpoint_type            = var.sm_endpoint_type
}

# A public certificate engine, consisting of a certificate authority (LetEncrypt)
# and a DNS provider authorisation (CIS) are configured as a pre-requisite to
# secrets manager generating certificates

locals {
  ibmcloud_secret_store_api_key = var.ibmcloud_secret_store_api_key == null ? var.ibmcloud_api_key : var.ibmcloud_secret_store_api_key
}

module "secrets_manager_public_cert_engine" {
  count   = var.existing_sm_instance_guid == null ? 1 : 0
  source  = "terraform-ibm-modules/secrets-manager-public-cert-engine/ibm"
  version = "1.0.4"
  providers = {
    ibm              = ibm
    ibm.secret-store = ibm.secret-store
  }
  secrets_manager_guid                      = local.sm_guid
  region                                    = local.sm_region
  service_endpoints                         = var.sm_endpoint_type
  internet_services_crn                     = var.cis_id
  ibmcloud_cis_api_key                      = var.ibmcloud_api_key
  dns_config_name                           = var.dns_provider_name
  ca_config_name                            = var.ca_name
  acme_letsencrypt_private_key              = var.acme_letsencrypt_private_key
  private_key_secrets_manager_instance_guid = var.private_key_secrets_manager_instance_guid
  private_key_secrets_manager_secret_id     = var.private_key_secrets_manager_secret_id
  private_key_secrets_manager_region        = var.private_key_secrets_manager_region
}

##############################################################################
# Secrets Manager public certificate order
##############################################################################

module "secrets_manager_public_certificate" {
  source     = "../../"
  depends_on = [module.secrets_manager_public_cert_engine]

  cert_common_name      = local.cert_common_name
  cert_description      = "Certificate for ${local.cert_common_name} domain"
  cert_name             = "${var.prefix}-example-public-cert"
  cert_secrets_group_id = module.secrets_manager_secret_group.secret_group_id

  secrets_manager_ca_name           = var.ca_name
  secrets_manager_dns_provider_name = var.dns_provider_name

  secrets_manager_guid   = local.sm_guid
  secrets_manager_region = local.sm_region
  service_endpoints      = var.sm_endpoint_type
}
