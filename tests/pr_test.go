// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"log"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testschematic"
)

// Use existing resource group
const resourceGroup = "geretain-test-resources"
const terraformDir = "examples/complete"

// Define a struct with fields that match the structure of the YAML data
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

const bestRegionYAMLPath = "../common-dev-assets/common-go-assets/cloudinfo-region-secmgr-prefs.yaml"

var permanentResources map[string]interface{}

// TestMain will be run before any parallel tests, used to read data from yaml for use with tests
func TestMain(m *testing.M) {
	var err error
	permanentResources, err = common.LoadMapFromYaml(yamlLocation)
	if err != nil {
		log.Fatal(err)
	}

	os.Exit(m.Run())
}

func setupOptions(t *testing.T, prefix string, dir string) *testhelper.TestOptions {

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  dir,
		Prefix:        prefix,
		ResourceGroup: resourceGroup,
		TerraformVars: map[string]interface{}{
			"existing_sm_instance_guid":   permanentResources["secretsManagerGuid"],
			"existing_sm_instance_region": permanentResources["secretsManagerRegion"],
			"cis_id":                      permanentResources["cisInstanceId"],
			"ca_name":                     permanentResources["certificateAuthorityName"],
			"dns_provider_name":           permanentResources["dnsProviderName"],
		},
	})

	return options
}

// To avoid race condition while creating certs, these tests execution is sequential
func TestRunDefaultExample(t *testing.T) {

	options := setupOptions(t, "sm-public-cert", terraformDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunUpgradeExample(t *testing.T) {

	options := setupOptions(t, "sm-public-cert-upg", terraformDir)

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}

func TestPrivateInSchematics(t *testing.T) {
	t.Parallel()

	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		Prefix:  "sm-pub-cert-priv",
		TarIncludePatterns: []string{
			"*.tf",
			terraformDir + "/*.tf",
		},
		ResourceGroup:          resourceGroup,
		TemplateFolder:         terraformDir,
		Tags:                   []string{"test-schematic"},
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 80,
		BestRegionYAMLPath:     bestRegionYAMLPath,
	})

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "resource_tags", Value: options.Tags, DataType: "list(string)"},
		{Name: "region", Value: options.Region, DataType: "string"},
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
		{Name: "existing_sm_instance_guid", Value: permanentResources["privateOnlySecMgrGuid"], DataType: "string"},
		{Name: "existing_sm_instance_region", Value: permanentResources["privateOnlySecMgrRegion"], DataType: "string"},
		{Name: "cis_id", Value: permanentResources["cisInstanceId"], DataType: "string"},
		{Name: "ca_name", Value: permanentResources["certificateAuthorityName"], DataType: "string"},
		{Name: "dns_provider_name", Value: permanentResources["dnsProviderName"], DataType: "string"},
		{Name: "sm_endpoint_type", Value: "private", DataType: "string"},
	}

	err := options.RunSchematicTest()
	assert.Nil(t, err, "This should not have errored")
}
