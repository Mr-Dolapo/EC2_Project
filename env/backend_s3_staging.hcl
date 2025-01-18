key    = "terraform/state/staging/terraform.tfstate"
bucket = "dolapo-staging-env-bucket"
region = "us-east-1"
encrypt = true
dynamodb_table = "state-lock"

# terraform init -migrate-state -backend-config="env/backend_s3_staging.hcl"