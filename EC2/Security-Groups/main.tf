variable "ec2_sg_name" {}
variable "vpc_id" {}
variable "ec2_jenkins_sg_name" {}


output "ec2_sg_ssh_http_id" {
  value = aws_security_group.ec2_sg_ssh_http.id
}

output "Jenkins_SG_8080_id" {
  value = aws_security_group.Jenkins_SG_8080.id
}

output "RDS_3306_id" {
  value = aws_security_group.RDS_3306.id
}


resource "aws_security_group" "ec2_sg_ssh_http" {
  name        = var.ec2_sg_name
  description = "Enable the Port 22(SSH) & Port 80(http)"
  vpc_id      = var.vpc_id

  # ssh for terraform remote exec
  ingress {
    description = "Allow remote SSH from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  #http
  ingress {
    description = "Allow remote SSH from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  #https
  ingress {
    description = "Allow HTTP request from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  #Allow all external Traffic
  egress {
    description = "Allow outgoing request"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Group to allow SSH(22) and HTTP(80)"
  }
}

resource "aws_security_group" "Jenkins_SG_8080" {
  name        = var.ec2_jenkins_sg_name
  description = "Enable the Port 5000"
  vpc_id      = var.vpc_id

  # ssh for terraform remote exec
  ingress {
    description = "Allow 5000 Port from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
  }
  tags = {
    Name = "Security Group to allow Port-5000"
  }
}

resource "aws_security_group" "RDS_3306" {
  name        = "RDS_3306"
  description = "Enable the Port 3306 for RDS"
  vpc_id      = var.vpc_id

  # ssh for terraform remote exec
  ingress {
    description = "Allow 3306 Port from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }
  tags = {
    Name = "Security Group to allow Port-3306"
  }
}