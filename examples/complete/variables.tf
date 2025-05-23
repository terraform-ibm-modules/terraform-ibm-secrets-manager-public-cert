variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "ibmcloud_secret_store_api_key" {
  type        = string
  description = "The IBM Cloud API token when the private key secrets manager is in a different account"
  sensitive   = true
  default     = null
}

variable "ca_name" {
  type        = string
  description = "Secret Managers certificate authority name"
  default     = "certificate-ca"
}

variable "dns_provider_name" {
  type        = string
  description = "Secret Managers DNS provider name"
  default     = "certificate-dns"
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
  default     = "certificate-smpc"
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

variable "private_key_secrets_manager_instance_guid" {
  type        = string
  description = "The Secrets Manager instance GUID of the Secrets Manager containing your ACME private key. Required if acme_letsencrypt_private_key is not set."
  default     = null
}

variable "private_key_secrets_manager_secret_id" {
  type        = string
  description = "The secret ID of your ACME private key. Required if acme_letsencrypt_private_key is not set. If both are set, this value will be used as the private key."
  default     = null
}

variable "private_key_secrets_manager_region" {
  type        = string
  description = "The region of the Secrets Manager instance containing your ACME private key. (Only needed if different from the region variable)"
  default     = null
}

variable "sm_allowed_network" {
  type        = string
  description = "The types of service endpoints to set on the Secrets Manager instance. Possible values are `private-only` or `public-and-private`."
  default     = "public-and-private"
  validation {
    condition     = contains(["private-only", "public-and-private"], var.sm_allowed_network)
    error_message = "The specified sm_allowed_network is not a valid selection!"
  }
}

variable "sm_endpoint_type" {
  type        = string
  description = "The type of endpoint (public or private) to connect to the Secrets Manager API."
  default     = "public"
  validation {
    condition     = contains(["public", "private"], var.sm_endpoint_type)
    error_message = "The specified sm_endpoint_type is not a valid selection!"
  }
}
