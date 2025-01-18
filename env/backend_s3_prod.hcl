key    = "terraform/state/prod/terraform.tfstate"
bucket = "dolapo-staging-prod-bucket"
region = "us-east-1"
encrypt = true
dynamodb_table = "state-lock"

# terraform init -migrate-state -backend-config="env/backend_s3_prod.hcl"