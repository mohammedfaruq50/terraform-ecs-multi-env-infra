terraform {
  backend "s3" {
    bucket         = "faruqs3bucket"
    key            = "project/staging/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}
