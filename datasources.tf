####################################################################################################
# Data Source: AWS AMI for Ubuntu Server
#
# This data source retrieves the most recent Ubuntu AMI owned by Canonical (owner ID 099720109477).
# It uses a filter to search for AMIs matching the specified naming pattern for Ubuntu 24.04.
####################################################################################################
data "aws_ami" "server_ami" {
  most_recent = true                       # Return only the most recent AMI matching the filters
  owners      = ["099720109477"]            # Owner ID for Canonical (Ubuntu images)

  filter {
    name   = "name"                        # Filter on the AMI name
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    # Filter values specify the naming pattern for Ubuntu 24.04 AMIs using gp3 SSDs
  }
}

####################################################################################################
# Data Source: AWS Secrets Manager - Secret Retrieval
#
# This data source retrieves a secret from AWS Secrets Manager.
# The secret identified here ("my-ip-address") stores the IP address used in the project.
####################################################################################################
data "aws_secretsmanager_secret" "ip_address_secret" {
  name = "my-ip-address"  # Name (or ARN) of the secret to retrieve
}

####################################################################################################
# Data Source: AWS Secrets Manager Secret Version
#
# This resource retrieves the current version of the secret from AWS Secrets Manager.
# It is used to access the actual secret value (e.g., an IP address) for use in the configuration.
####################################################################################################
data "aws_secretsmanager_secret_version" "ip_address_version" {
  secret_id = data.aws_secretsmanager_secret.ip_address_secret.id
  # References the secret's ID from the previous data source to fetch its current version and value.
}
