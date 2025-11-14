<!-- Update the title -->
# Secrets manager public cert module

[![Graduated (Supported)](https://img.shields.io/badge/Status-Graduated%20(Supported)-brightgreen)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-secrets-manager-public-cert?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-secrets-manager-public-cert/releases/latest)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

<!-- Add a description of module(s) in this repo -->
This module orders a public certificate in an IBM Secrets Manager secrets group from an existing Secrets Manager instance that has a public certificate engine configured.

The module supports the following secret types:

- [Public Certificates](https://cloud.ibm.com/docs/secrets-manager?topic=secrets-manager-certificates&interface=ui#order-certificates) ordered from third parties


<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-secrets-manager-public-cert](#terraform-ibm-secrets-manager-public-cert)
* [Examples](./examples)
    * <div style="display: inline-block;"><a href="./examples/complete">Complete example</a></div> <div style="display: inline-block; vertical-align: middle;"><a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=smpc-complete-example&repository=https://github.com/terraform-ibm-modules/terraform-ibm-secrets-manager-public-cert/tree/main/examples/complete" target="_blank"><img src="https://cloud.ibm.com/media/docs/images/icons/Deploy_to_cloud.svg" alt="Deploy to IBM Cloud button"></a></div>
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->


<!--
If this repo contains any reference architectures, uncomment the heading below and links to them.
(Usually in the `/reference-architectures` directory.)
See "Reference architecture" in Authoring Guidelines in the public documentation at
https://terraform-ibm-modules.github.io/documentation/#/implementation-guidelines?id=reference-architecture
-->
<!-- ## Reference architectures -->


<!-- This heading should always match the name of the root level module (aka the repo name) -->
## secrets-manager-public-cert-module

### Usage

```hcl
module "public_certificate" {
  source                = "terraform-ibm-modules/secrets-manager-public-cert/ibm"
  version               = "X.X.X" # Replace "X.X.X" with a release version to lock into a specific release

  cert_common_name      = "<common_name_for_domain>"
  cert_description      = "Certificate for example domain"
  cert_name             = "example-public-certificate"
  cert_secrets_group_id = "<secrets_manager_secret_group_id>" # pragma: allowlist secret

  secrets_manager_ca_name           = "My CA Config"
  secrets_manager_dns_provider_name = "My DNS Provider Config"

  secrets_manager_guid   = "<secrets_manager_instance_id>" # pragma: allowlist secret
  secrets_manager_region = "us-south"
}

##############################################################################
# Example for CA with two DNS domains
##############################################################################
# Engine CA and first DNS config
##############################################################################
module "secrets_manager_public_cert_engine" {
  source                       = "terraform-ibm-modules/secrets-manager-public-cert/ibm"
  version                      = "X.X.X" # Replace "X.X.X" with a release version to lock into a specific release
  secrets_manager_guid         = "<secrets_manager_guid>"
  region                       = "us-south"
  internet_services_crn        = ibm_cis.cis_instance.id
  ibmcloud_cis_api_key         = var.ibmcloud_api_key
  dns_config_name              = "DNS Provider Config"
  ca_config_name               = "CA Config"
  acme_letsencrypt_private_key = var.acme_letsencrypt_private_key
}
##############################################################################
# Engine second DNS config
##############################################################################
module "secrets_manager_public_cert_engine_second_dns" {
  source                = "terraform-ibm-modules/secrets-manager-public-cert/ibm"
  version               = "X.X.X" # Replace "X.X.X" with a release version to lock into a specific release
  secrets_manager_guid  = "<secrets_manager_guid>"
  region                = "us-south"
  internet_services_crn = ibm_cis.cis_instance.id
  ibmcloud_cis_api_key  = var.ibmcloud_api_key
  dns_config_name       = "Second DNS Provider Config"
}
##############################################################################
# Certificate in two DNS configuration
##############################################################################
module "secrets_manager_public_certificate" {
  source                = "terraform-ibm-modules/secrets-manager-public-cert/ibm"
  version               = "X.X.X" # Replace "X.X.X" with a release version to lock into a specific release

  cert_common_name      = var.cert_common_name
  cert_description      = "Certificate for ${var.cert_common_name} domain"
  cert_name             = "goldeneye-instance-sm-public-cert"
  cert_secrets_group_id = "<secret_group_id>"

  secrets_manager_ca_name           = "CA Config"
  secrets_manager_dns_provider_name = "Second DNS Provider Config"

  secrets_manager_guid   = "<secrets_manager_guid>"
  secrets_manager_region = "us-south"

}
```

### Required IAM access policies

- Account Management
    - Resource Group service
    - Viewer platform access
- IAM Services
    - Secrets Manager service
        - Editor platform access
        - Manager service access

<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.79.0, < 2.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_sm_public_certificate.secrets_manager_public_certificate](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/sm_public_certificate) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bundle_certs"></a> [bundle\_certs](#input\_bundle\_certs) | Indicates whether the issued certificate is bundled with intermediate certificates. | `bool` | `true` | no |
| <a name="input_cert_alt_names"></a> [cert\_alt\_names](#input\_cert\_alt\_names) | Optional, Alternate names for the certificate to be created | `list(string)` | `null` | no |
| <a name="input_cert_common_name"></a> [cert\_common\_name](#input\_cert\_common\_name) | Fully qualified domain name or host domain name for the certificate to be created | `string` | n/a | yes |
| <a name="input_cert_custom_metadata"></a> [cert\_custom\_metadata](#input\_cert\_custom\_metadata) | Optional, Custom metadata for the certificate to be created | `map(string)` | <pre>{<br/>  "collection_total": 1,<br/>  "collection_type": "application/vnd.ibm.secrets-manager.secret+json"<br/>}</pre> | no |
| <a name="input_cert_description"></a> [cert\_description](#input\_cert\_description) | Optional, Extended description of certificate to be created. To protect privacy, do not use personal data, such as name or location, as a description for certificate | `string` | `null` | no |
| <a name="input_cert_labels"></a> [cert\_labels](#input\_cert\_labels) | Optional, Labels for the certificate to be created | `list(string)` | `[]` | no |
| <a name="input_cert_name"></a> [cert\_name](#input\_cert\_name) | The name of the certificate to be created in Secrets Manager | `string` | n/a | yes |
| <a name="input_cert_rotation"></a> [cert\_rotation](#input\_cert\_rotation) | Optional, Rotation policy for the certificate to be created | <pre>object({<br/>    auto_rotate = optional(bool),<br/>    rotate_keys = optional(bool)<br/>  })</pre> | <pre>{<br/>  "auto_rotate": true,<br/>  "rotate_keys": false<br/>}</pre> | no |
| <a name="input_cert_secrets_group_id"></a> [cert\_secrets\_group\_id](#input\_cert\_secrets\_group\_id) | Optional, Id of Secrets Manager secret group to store the certificate in | `string` | `"default"` | no |
| <a name="input_key_algorithm"></a> [key\_algorithm](#input\_key\_algorithm) | The identifier for the cryptographic algorithm to be used to generate the public key that is associated with the certificate. | `string` | `"RSA2048"` | no |
| <a name="input_secrets_manager_ca_name"></a> [secrets\_manager\_ca\_name](#input\_secrets\_manager\_ca\_name) | The name of the Secrets Manager certificate authority | `string` | n/a | yes |
| <a name="input_secrets_manager_dns_provider_name"></a> [secrets\_manager\_dns\_provider\_name](#input\_secrets\_manager\_dns\_provider\_name) | The name of the Secrets Manager DNS provider | `string` | n/a | yes |
| <a name="input_secrets_manager_guid"></a> [secrets\_manager\_guid](#input\_secrets\_manager\_guid) | Secrets Manager GUID | `string` | n/a | yes |
| <a name="input_secrets_manager_region"></a> [secrets\_manager\_region](#input\_secrets\_manager\_region) | Region the Secrets Manager instance is in | `string` | n/a | yes |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | Service endpoint type to communicate with the provided secrets manager instance. Possible values are `public` or `private` | `string` | `"public"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Public certificates secrets manager secret resource ID |
| <a name="output_secret_crn"></a> [secret\_crn](#output\_secret\_crn) | Public certificates secrets manager secret CRN |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | Public certificates secrets manager secret unique ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
