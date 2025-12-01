##############################################################################
# Input Variables
##############################################################################

# Common

##############################################################################

# Certificate
variable "cert_common_name" {
  type        = string
  description = "Fully qualified domain name or host domain name for the certificate to be created"

  validation {
    condition     = length(var.cert_common_name) >= 4 && length(var.cert_common_name) <= 128
    error_message = "length of cert_common_name must be >= 4 and <= 128"
  }

  validation {
    condition     = can(regex("(.*?)", var.cert_common_name))
    error_message = "cert_common_name must match regular expression /(.*?)/"
  }
}

variable "cert_description" {
  type        = string
  description = "Optional, Extended description of certificate to be created. To protect privacy, do not use personal data, such as name or location, as a description for certificate"
  default     = null

  validation {
    condition     = var.cert_description == null ? true : length(var.cert_description) <= 1024
    error_message = "length of cert_description must be <= 1024"
  }

  validation {
    condition     = var.cert_description == null ? true : can(regex("(.*?)", var.cert_description))
    error_message = "cert_description must match regular expression /(.*?)/"
  }
}

variable "cert_name" {
  type        = string
  description = "The name of the certificate to be created in Secrets Manager"

  validation {
    condition     = length(var.cert_name) > 1 && length(var.cert_name) <= 256
    error_message = "length of cert_name must be > 1 and <= 256"
  }

  validation {
    condition     = can(regex("^\\w(([\\w-.]+)?\\w)?$", var.cert_name))
    error_message = "cert_name must match regular expression /^\\w(([\\w-.]+)?\\w)?$/"
  }
}

variable "cert_alt_names" {
  type        = list(string)
  description = "Optional, Alternate names for the certificate to be created"
  default     = null

  validation {
    condition     = var.cert_alt_names == null ? true : length(var.cert_alt_names) < 100
    error_message = "length of cert_alt_names must be < 100"
  }

  validation {
    condition = var.cert_alt_names == null ? true : alltrue([
      for cert_alt_name in var.cert_alt_names : can(regex("^(.*?)$", cert_alt_name))
    ])
    error_message = "list items must match regular expression /^(.*?)$/"
  }
}

variable "cert_secrets_group_id" {
  type        = string
  description = "Optional, Id of Secrets Manager secret group to store the certificate in"
  default     = "default"

  validation {
    condition     = var.cert_secrets_group_id == null ? true : length(var.cert_secrets_group_id) >= 7 && length(var.cert_secrets_group_id) <= 36
    error_message = "length of cert_secrets_group_id must be >= 7 and <= 36"
  }

  validation {
    condition     = can(regex("^([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}|default)$", var.cert_secrets_group_id))
    error_message = "cert_secrets_group_id match regular expression /^([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}|default)$/"
  }
}

variable "cert_rotation" {
  type = object({
    auto_rotate = optional(bool),
    rotate_keys = optional(bool)
  })
  description = "Optional, Rotation policy for the certificate to be created"
  default = {
    auto_rotate = true,
    rotate_keys = false
  }
}

variable "bundle_certs" {
  type        = bool
  description = "Indicates whether the issued certificate is bundled with intermediate certificates."
  default     = true

  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.bundle_certs))
    error_message = "The bundle_certs must be either true or false."
  }
}

variable "key_algorithm" {
  type        = string
  description = "The identifier for the cryptographic algorithm to be used to generate the public key that is associated with the certificate."
  default     = "RSA2048"

  validation {
    condition     = contains(["RSA2048", "RSA4096", "ECDSA256", "ECDSA384"], var.key_algorithm)
    error_message = "Invalid input, options: RSA2048, RSA4096, ECDSA256, ECDSA384"
  }
}

##############################################################################

# Secrets Manager
variable "secrets_manager_ca_name" {
  type        = string
  description = "The name of the Secrets Manager certificate authority"
}

variable "secrets_manager_dns_provider_name" {
  type        = string
  description = "The name of the Secrets Manager DNS provider"
}

variable "secrets_manager_guid" {
  type        = string
  description = "Secrets Manager GUID"
}

variable "secrets_manager_region" {
  type        = string
  description = "Region the Secrets Manager instance is in"
}

variable "endpoint_type" {
  type        = string
  description = "Service endpoint type to communicate with the provided secrets manager instance. Possible values are `public` or `private`"
  default     = "public"
  validation {
    condition     = contains(["public", "private"], var.endpoint_type)
    error_message = "The specified endpoint_type is not a valid selection!"
  }
}

variable "cert_custom_metadata" {
  type        = map(string)
  description = "Optional, Custom metadata for the certificate to be created"
  default = {
    collection_type  = "application/vnd.ibm.secrets-manager.secret+json",
    collection_total = 1
  }
}

variable "cert_labels" {
  type        = list(string)
  description = "Optional, Labels for the certificate to be created"
  default     = []

  validation {
    condition     = length(var.cert_labels) <= 30
    error_message = "length of cert_labels must be <= 30"
  }

  validation {
    condition = alltrue([
      for cert_label in var.cert_labels : can(regex("(.*?)", cert_label)) && length(cert_label) >= 2 && length(cert_label) <= 30
    ])
    error_message = "list items must match regular expression /(.*?)/, length of list items must be >= 2 and <= 30"
  }
}
