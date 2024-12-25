variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "cidr_private_subnet" {}
variable "availability_zone" {}


output "vpc_id" {
  value = aws_vpc.Deployment_VPC.id
}

output "Public_Subnet_id" {
  value = aws_subnet.Public_Subnet.*.id
}


output "Private_Subnet_id" {
  value = aws_subnet.Private_Subnet.*.id
}

#Create a VPC for Deployment
resource "aws_vpc" "Deployment_VPC" {
  cidr_block       = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

#Create 2 Public subnet with differnet availability Zones
resource "aws_subnet" "Public_Subnet" {
  count      = length(var.cidr_public_subnet)
  vpc_id     = aws_vpc.Deployment_VPC.id
  cidr_block = element(var.cidr_public_subnet, count.index)
  tags = {
    Name = "Public_Subnet-${count.index+1}"
  }
  availability_zone=element(var.availability_zone,count.index)
}

#Create 2 Private subnet with differnet availability Zones
resource "aws_subnet" "Private_Subnet" {
  count = length(var.cidr_private_subnet)
  vpc_id     = aws_vpc.Deployment_VPC.id
  cidr_block = element(var.cidr_private_subnet,count.index)
  tags = {
    Name = "Private_Subnet-${count.index+1}"
  }
  availability_zone=element(var.availability_zone,count.index)
}

#Create Internet Gateway
resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.Deployment_VPC.id

  tags = {
    Name = "Internet Gateway"
  }
}

#Create Route Table for Public Subnets
resource "aws_route_table" "Public_Route_Table" {
  vpc_id = aws_vpc.Deployment_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }

  tags = {
    Name = "${var.vpc_name}-Public_Route_Table"
  }
}

#Associate Public Subnets with Route table
resource "aws_route_table_association" "RouteTableAssociation_PublicSubnet" {
  count          = length(aws_subnet.Public_Subnet)
  subnet_id      = aws_subnet.Public_Subnet[count.index].id
  route_table_id = aws_route_table.Public_Route_Table.id
}

#Create Route Table for Private Subnets
resource "aws_route_table" "Private_Route_Table" {
  vpc_id = aws_vpc.Deployment_VPC.id

  tags = {
    Name = "${var.vpc_name}-Private_Route_Table"
  }
}

#Associate Private Subnets with Route table
resource "aws_route_table_association" "RouteTableAssociation_PrivateSubnet" {
  count          = length(aws_subnet.Private_Subnet)
  subnet_id      = aws_subnet.Private_Subnet[count.index].id
  route_table_id = aws_route_table.Private_Route_Table.id
}

