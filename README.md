# AWS WAF

This project shows how to setup AWS WAF.

In order to be able to run the project you will need `terraform.tfvars` where you will need to setup the AWS access credentials.

`access_key = "AWS_ACCESS_KEY"`

`secret_key = "AWS_SECRET_KEY"`

`region = "eu-west-1"`

`waf_name = "my-api"`

After correct configuration you will be able to run the project with terraform commands.

$ terraform init

$ terraform plan

$ terraform apply