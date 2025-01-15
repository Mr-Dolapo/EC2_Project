resource "aws_vpc" "default_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = "default"
  }
}

resource "aws_subnet" "default_public_subnet" {
  vpc_id                  = aws_vpc.default_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "default-public-subnet"
  }
}

resource "aws_internet_gateway" "default_igw" {
  vpc_id = aws_vpc.default_vpc.id

  tags = {
    Name = "default-vpc"
  }
}

resource "aws_route_table" "default_route_table" {
  vpc_id = aws_vpc.default_vpc.id

  tags = {
    Name = "default-route-table"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.default_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default_igw.id
}

resource "aws_route_table_association" "default_association" {
  subnet_id      = aws_subnet.default_public_subnet.id
  route_table_id = aws_route_table.default_route_table.id
}

resource "aws_security_group" "default_sg" {
  name        = "default-sg"
  description = "default security group"
  vpc_id      = aws_vpc.default_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["81.104.136.168/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_key_pair" "default_key_pair" {
#   key_name   = "default-key"
#   public_key = file("~/.ssh/default_key.pub")
# }

resource "aws_instance" "default_node" {
  ami                    = data.aws_ami.server_ami.id
  instance_type          = "t2.micro"
  # key_name               = aws_key_pair.default_key_pair.id
  vpc_security_group_ids = [aws_security_group.default_sg.id]
  subnet_id              = aws_subnet.default_public_subnet.id
  # user_data = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "default-node"
  }

  # provisioner "local-exec" {
  #   command = templatefile("${var.host_os}-ssh-config.tpl", {
  #       hostname = self.public_ip,
  #       user = "ubuntu",
  #       identityfile = "~/.ssh/default_key"
  #   })
  #   interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  # }
}
