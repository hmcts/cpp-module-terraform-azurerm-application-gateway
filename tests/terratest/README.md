## About
This directory contains unit tests and integration tests.
The integration tests use the [examples-complete](../../examples/complete). This will create an
application gateway and 2 vm that will allow us to connect to an endpoint that should return a
http 200 response.


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
