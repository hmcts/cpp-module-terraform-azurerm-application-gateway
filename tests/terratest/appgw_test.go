package test

// import (
// 	"os"
// 	"path"
// 	"testing"

// 	"github.com/gruntwork-io/terratest/modules/random"
// 	"github.com/gruntwork-io/terratest/modules/terraform"
// 	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
// 	terraformCore "github.com/hashicorp/terraform/terraform"
// 	"github.com/stretchr/testify/assert"
// )
import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)


//Testing the secure-file-transfer Module
func TestTerraformAzureAppGW(t *testing.T) {
	t.Parallel()

	subscriptionID := "e6b5053b-4c38-4475-a835-a025aeb3d8c7"
	uniquePostfix := random.UniqueId()

	// set up variables for other module variables so assertions may be made on them later

	expectedfrontend_resource_group_name := "RG-LAB-DMZ-01"
	expectedfrontend_virtual_network_name := "VN-LAB-DMZ-01"
	expectedfrontend_address_prefixes := ["10.4.4.0/28"]
	expectedbackend_resource_group_name := "RG-LAB-INT-01"
	expectedbackend_virtual_network_name := "VN-LAB-INT-01"
	expectedbackend_address_prefixes := ["10.1.14.0/28"]

	expectednamespace   := "cpp"
	expectedcostcode    := "terratest"
	expectedowner       := "EI"
	expectedenvironment := "nonlive"
	expectedapplication :="atlassian"

	// Terraform plan.out File Path
	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../..", "examples/complete")
	planFilePath := filepath.Join(exampleFolder, "plan.out")

	terraformPlanOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../",
		Upgrade:      true,

		// Variables to pass to our Terraform code using -var-file options
		// VarFiles: []string{"for_terratest.tfvars"},


		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"frontend_resource_group_name": 	expectedfrontend_resource_group_name
			"frontend_virtual_network_name": 	expectedfrontend_virtual_network_name
			"frontend_address_prefixes": 		expectedfrontend_address_prefixes
			"backend_resource_group_name": 		expectedbackend_resource_group_name
			"backend_virtual_network_name": 	expectedbackend_virtual_network_name
			"backend_address_prefixes": 		expectedbackend_address_prefixes

			"namespace": 	expectednamespace
			"costcode": 	expectedcostcode
			"owner": 		expectedowner
			"environment": 	expectedenvironment
			"application": 	expectedapplication

		},

		// Configure a plan file path so we can introspect the plan and make assertions about it.
		PlanFilePath: planFilePath,
	})

	// website::tag::4:: At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2:: Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// website::tag::3:: Run `terraform output` to get the values of output variables
	appgwid := terraform.Output(t, terraformOptions, "appgw_id")
	appgwname := terraform.Output(t, terraformOptions, "appgw_name")
	appgwpublicipaddress := terraform.Output(t, terraformOptions, "appgw_public_ip_address")

}
