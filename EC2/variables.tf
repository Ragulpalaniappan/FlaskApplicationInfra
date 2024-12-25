variable "vpc_cidr" {
  description = "To Describe the CIDR Range for the VPC"
  type = string
}

variable "vpc_name" {
  type        = string
  description = "DevOps Project 1 VPC 1"
}

variable "cidr_public_subnet" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
}

variable "cidr_private_subnet" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
}

variable "availability_zone" {
  description = "TO Pass Availability Zone"
  type        = list(string)
}

variable "public_key" {
  description = "Public key used for EC2 creation"
  type        = string
}

