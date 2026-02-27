terraform {
  backend "s3" {
    bucket         = "faruqs3bucket"
    key            = "project/prod/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}

