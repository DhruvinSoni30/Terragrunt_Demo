# Configure S3 as a backend
remote_state {
  backend = "s3"
  config = {
    bucket = "demo-bucket-${get_aws_account_id()}"
    region = "ap-south-1"
    key    = "${path_relative_to_include()}/terraform.tfstate"
}

generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
}
}
