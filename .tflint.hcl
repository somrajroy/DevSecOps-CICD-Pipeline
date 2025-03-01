config {
    force = false # Ensures that rules are not forcefully enabled.
    disabled_by_default = false
    # varfile = ["terraform.tfvars", "terraform2.tfvars"]
}


plugin "aws" {
  enabled = true
  version = "0.24.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
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