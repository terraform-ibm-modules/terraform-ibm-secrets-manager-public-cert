variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "ca_name" {
  type        = string
  description = "Secret Managers certificate authority name"
  default     = "goldeneye-ca"
}

variable "dns_provider_name" {
  type        = string
  description = "Secret Managers DNS provider name"
  default     = "goldeneye-dns"
}

variable "acme_letsencrypt_private_key" {
  type        = string
  description = "Lets Encrypt private key for certificate authority. If not provided, all created public certs will be immediately deactivated."
  default     = null
  sensitive   = true
}

variable "cis_id" {
  type        = string
  description = "Cloud Internet Service ID"
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources created by this example"
  default     = "goldeneye-smpc"
}

variable "region" {
  type        = string
  description = "Region to provision all resources created by this example"
  default     = "us-east"
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example, if unset a new resource group will be created"
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "existing_sm_instance_guid" {
  type        = string
  description = "Existing Secrets Manager GUID. The existing Secret Manager instance must have private certificate engine configured. If not provided an new instance will be provisioned."
  default     = null
}

variable "existing_sm_instance_region" {
  type        = string
  description = "Required if value is passed into var.existing_sm_instance_guid"
  default     = null
}

variable "domain_name" {
  type        = string
  description = "Domain name use to generate certificate common name"
  default     = "goldeneye.dev.cloud.ibm.com"
}
