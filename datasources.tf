data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# Retrieve the secret from AWS Secrets Manager
data "aws_secretsmanager_secret" "ip_address_secret" {
  name = "my-ip-address" # This is the name or ARN of your secret
}

# Retrieve the value of the secret
data "aws_secretsmanager_secret_version" "ip_address_version" {
  secret_id = data.aws_secretsmanager_secret.ip_address_secret.id
}
