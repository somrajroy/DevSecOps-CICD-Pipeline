terraform {
  backend "s3" {
    bucket  = "tfstategithubactions"
    region  = "us-west-2"
    key     = "terraform.tfstate"
    encrypt = true
  }

  required_version = ">=0.13.0"

}