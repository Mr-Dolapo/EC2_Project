####################################################################################################
# AWS VPC - Main Virtual Private Cloud
#
# This resource creates the main VPC for the environment using the provided CIDR block.
# DNS hostnames and DNS support are enabled to allow resource naming and resolution.
####################################################################################################
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block_vpc  # The IP address range for the VPC, provided as a variable.
  enable_dns_hostnames = true                # Enable DNS hostnames for instances launched in the VPC.
  enable_dns_support   = true                # Enable DNS resolution within the VPC.

  tags = {
    Name = "${var.environment}-vpc"           # Tag for identifying the VPC by environment.
  }
}

####################################################################################################
# AWS Subnet - Public Subnet
#
# This resource creates a public subnet within the VPC in the specified availability zone.
# Public IP addresses will be mapped on launch to instances within this subnet.
####################################################################################################
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id               # Associate the subnet with the main VPC.
  cidr_block              = var.cidr_block_public_subnet # The CIDR block for the public subnet.
  map_public_ip_on_launch = true                         # Automatically assign public IP addresses to instances.
  availability_zone       = "us-east-1a"                # Specify the availability zone for the subnet.

  tags = {
    Name = "${var.environment}-public-subnet"               # Tag to identify the subnet by environment.
  }
}

####################################################################################################
# AWS Internet Gateway
#
# This resource creates an Internet Gateway for the VPC to enable connectivity to the internet.
####################################################################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id  # Attach the Internet Gateway to the main VPC.

  tags = {
    Name = "${var.environment}-igw"  # Tag for identifying the gateway by environment.
  }
}

####################################################################################################
# AWS Route Table
#
# This resource creates a route table for the VPC.
# It will be used to route traffic destined for the internet through the Internet Gateway.
####################################################################################################
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id  # Associate the route table with the main VPC.

  tags = {
    Name = "${var.environment}-route-table"  # Tag to identify the route table by environment.
  }
}

####################################################################################################
# AWS Route
#
# This resource creates a route in the route table that directs all outbound IPv4 traffic
# (0.0.0.0/0) to the Internet Gateway.
####################################################################################################
resource "aws_route" "route" {
  route_table_id         = aws_route_table.route_table.id  # Reference the previously created route table.
  destination_cidr_block = var.cidr_block_destination_igw   # Destination CIDR block for internet traffic.
  gateway_id             = aws_internet_gateway.igw.id        # Route traffic via the Internet Gateway.
}

####################################################################################################
# AWS Route Table Association
#
# This resource associates the public subnet with the route table, ensuring that instances
# in the subnet use the defined routes.
####################################################################################################
resource "aws_route_table_association" "association" {
  subnet_id      = aws_subnet.public_subnet.id        # The public subnet to associate.
  route_table_id = aws_route_table.route_table.id       # The route table to be associated.
}

####################################################################################################
# AWS Security Group - General Security Group
#
# This resource creates a security group for the VPC.
# It allows inbound traffic from a specific IP address (fetched from Secrets Manager) and
# outbound traffic to any destination.
####################################################################################################
resource "aws_security_group" "security_group" {
  name        = "${var.environment}-security-group"  # Name of the security group, tagged by environment.
  description = "${var.environment} security group"   # A brief description of the security group.
  vpc_id      = aws_vpc.vpc.id                        # Associate the security group with the main VPC.

  # Ingress rule: Allow all inbound traffic from the IP address provided in the secret.
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # "-1" means all protocols.
    cidr_blocks = [
      jsondecode(data.aws_secretsmanager_secret_version.ip_address_version.secret_string)["my-ip-address"]
    ]
    # Retrieves the "my-ip-address" value from the secret stored in AWS Secrets Manager.
  }

  # Egress rule: Allow all outbound traffic to any destination.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-security-group"  # Tag for identification.
    Environment = "${var.environment}"                   # Environment tag.
  }
}

####################################################################################################
# AWS EC2 Instance
#
# This resource creates an EC2 instance using a specified AMI and instance type.
# The instance is launched in the public subnet with the security group defined above.
####################################################################################################
resource "aws_instance" "node" {
  ami           = data.aws_ami.server_ami.id            # Use the latest Ubuntu AMI retrieved from the data source.
  instance_type = var.instance_type                      # Instance type defined via variable.
  # key_name               = aws_key_pair.default_key_pair.id  # (Optional) SSH key for instance access.
  vpc_security_group_ids = [aws_security_group.security_group.id]  # Attach the defined security group.
  subnet_id              = aws_subnet.public_subnet.id         # Launch the instance in the public subnet.
  # user_data = file("userdata.tpl")  # (Optional) User data script for additional configuration.

  root_block_device {
    volume_size = 10  # Set the size of the root volume (in GB).
  }

  tags = {
    Name = "${var.environment}-node"  # Tag for identifying the instance.
  }

  # The following provisioner is commented out but can be used to update local SSH configuration
  # after the instance is created.
  # provisioner "local-exec" {
  #   command = templatefile("${var.host_os}-ssh-config.tpl", {
  #       hostname   = self.public_ip,
  #       user       = "ubuntu",
  #       identityfile = "~/.ssh/default_key"
  #   })
  #   interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  # }
}
