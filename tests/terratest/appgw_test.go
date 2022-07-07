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

	"github.com/gruntwork-io/terratest/modules/terraform"
)

//Testing the secure-file-transfer Module
func TestTerraformAzureAppGW(t *testing.T) {
	t.Parallel()

	//subscriptionID := "e6b5053b-4c38-4475-a835-a025aeb3d8c7"

	// website::tag::1:: Configure Terraform setting up a path to Terraform code.
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../example/complete",
		Upgrade:      true,
		VarFiles:     []string{"for_terratest.tfvars"},
	}

	// website::tag::4:: At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2:: Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// website::tag::3:: Run `terraform output` to get the values of output variables
	//appgwid := terraform.Output(t, terraformOptions, "appgw_id")
	//appgwname := terraform.Output(t, terraformOptions, "appgw_name")
	//appgwpublicipaddress := terraform.Output(t, terraformOptions, "appgw_public_ip_address")

}
