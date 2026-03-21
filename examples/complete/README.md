# Complete example

<!-- BEGIN SCHEMATICS DEPLOY HOOK -->
<p>
  <a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=secrets-manager-public-cert-complete-example&repository=https://github.com/terraform-ibm-modules/terraform-ibm-secrets-manager-public-cert/tree/main/examples/complete">
    <img src="https://img.shields.io/badge/Deploy%20with%20IBM%20Cloud%20Schematics-0f62fe?style=flat&logo=ibm&logoColor=white&labelColor=0f62fe" alt="Deploy with IBM Cloud Schematics">
  </a><br>
  ℹ️ Ctrl/Cmd+Click or right-click on the Schematics deploy button to open in a new tab.
</p>
<!-- END SCHEMATICS DEPLOY HOOK -->

An end-to-end example that uses the module's default variable values.
This example uses the IBM Cloud terraform provider to:
 - Create a new resource group if one is not passed in.
 - Create a new Secrets Manager instance if existing one not passed in. It creates a Secret Group as well.
 - Add a certificate authority and DNS provider to the Secrets Manager
 - Create a new public certificate

**NOTE:** If you do not provide a Let's Encrypt private key, the public certificate that is created will be immediately deactivated.
