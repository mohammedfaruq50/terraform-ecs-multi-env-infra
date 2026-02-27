terraform {
  backend "s3" {
    bucket         = "faruqs3bucket"
    key            = "project/dev/terraform.tfstate"
    region         = "us-west-2"
    //dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
