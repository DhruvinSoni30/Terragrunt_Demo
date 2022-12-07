terraform {
  source  = "tfr:///DhruvinSoni30/ec2-instance/aws?version=1.0.1"
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
  provider "aws" {
    profile = "default"
    region  = "ap-south-1"
}
EOF
}

inputs = {
  ami_id = "ami-074dc0a6f6c764218"
  availability_zone = "ap-south-1a"
  instance_type = "t2.micro"
  tags =  "my_ec2_instance_dev"
}

# Automatically find the root terragrunt.hcl and inherit its configuration
include {
  path = find_in_parent_folders()
}
