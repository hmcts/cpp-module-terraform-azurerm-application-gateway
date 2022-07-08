## Usage

From the root of the repo run
go mod init github.com/hmcts/cpp-module-terraform-azurerm-application-gateway
To execute the tests execute the following from within the test file's folder:

Ensure your go environment is setup.

```bash
go test -v pre_test.go
```

Run the terratest which will validate the module.
```bash
az login (non-live)
az account set --subscription 8cdb5405-7535-4349-92e9-f52bddc7833a
go test -v -timeout 30m appgw_test.go
```
