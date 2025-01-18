key    = "terraform/state/dev/terraform.tfstate"
bucket = "dolapo-dev-env-bucket"
region = "us-east-1"
encrypt = true
dynamodb_table = "state-lock"

# terraform init -migrate-state -backend-config="env/backend_s3_dev.hcl"