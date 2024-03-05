# Complete example

An end-to-end example that uses the module's default variable values.
This example uses the IBM Cloud terraform provider to:
 - Create a new resource group if one is not passed in.
 - Create a new Secrets Manager instance if existing one not passed in. It creates a Secret Group as well.
 - Add a certificate authority and DNS provider to the Secrets Manager
 - Create a new public certificate

**NOTE:** If you do not provide a Let's Encrypt private key, the public certificate that is created will be immediately deactivated.
