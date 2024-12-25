variable "instance_type" {}
variable "ami_id" {}
variable "tag_name" {}
variable "public_key" {}
variable "subnet_id" {}
variable "enable_public_ip_address" {}
variable "vpc_security_group_ids" {}
variable "user_data_install_apache" {}

output "EC2_Public_ip" {
    value = aws_instance.EC2Machine.public_ip 
}

output "EC2_id" {
    value = aws_instance.EC2Machine.id
}

output "EC2_instance_Subnet_id" {
  value = aws_instance.EC2Machine.subnet_id
}

resource "aws_instance" "EC2Machine" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  tags = {
    Name = var.tag_name
  }
  key_name                    = "aws_ec2_terraform"
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.enable_public_ip_address
  vpc_security_group_ids      = var.vpc_security_group_ids


  user_data = var.user_data_install_apache

  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
}

resource "aws_key_pair" "jenkins_ec2_instance_public_key" {
  key_name   = "aws_ec2_terraform"
  public_key = var.public_key
}