


provider "aws" {
  endpoints = {
      s3 = "sfo2.digitaloceanspaces.com"
  }
  access_key = "${var.do["spaces_access_key"]}"
  secret_key = "${var.do["spaces_secret_key"]}"
  region     = "us-west-1"

  skip_requesting_account_id = true
  skip_credentials_validation = true
  skip_get_ec2_platforms = true
  skip_metadata_api_check = true
}


resource "digitalocean_spaces_bucket" "bucket" {
	name = "es0000-bucket"
	acl = "private"
    region = "sfo2"
}
