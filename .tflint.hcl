plugin "aws" {
  enabled = true
  version = "0.24.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

config {
    call_module_type = "local"
    force = false
    disabled_by_default = false

  ignore_module = {
    "terraform-aws-modules/vpc/aws"            = true
    "terraform-aws-modules/security-group/aws" = true
  }
    # varfile = ["terraform.tfvars", "terraform2.tfvars"]
    # varfile : Set Terraform variables from tfvars files. 
    # If terraform.tfvars or any *.auto.tfvars files are present, they will be automatically loaded.
}

rule "terraform_unused_declarations" {
  enabled = true
}

# Disallow variable declarations without description.
rule "terraform_documented_variables" {
enabled = true
}

# Disallow variable declarations without type.
rule "terraform_typed_variables" {
enabled = true
}

# General Terraform rules
rule "terraform_deprecated_interpolation" {
  enabled = true
}