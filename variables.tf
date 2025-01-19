variable "environment" {
  description = "The environment for the infrastructure"
  type        = string
}
variable "cidr_block_vpc" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "cidr_block_public_subnet" {
  description = "CIDR block for the public subnet"
  type        = string
}
variable "cidr_block_destination_igw" {
  description = "CIDR block destination route for Internet Gateway"
  type        = string
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}




