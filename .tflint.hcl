# https://github.com/terraform-linters/tflint
# https://github.com/terraform-linters/tflint-ruleset-aws

plugin "aws" {
  enabled = true
  version = "0.37.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Disallow variables, data sources, and locals that are declared but never used.
rule "terraform_unused_declarations" {
  enabled = true
}

# Disallow variable declarations without description.
rule "terraform_documented_variables" {
enabled = true
}

# Disallow output declarations without description.
rule "terraform_documented_outputs" {
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