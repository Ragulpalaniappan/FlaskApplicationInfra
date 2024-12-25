module "Networking" {
   source               = "./Networking"
   vpc_cidr             = var.vpc_cidr
   vpc_name             = var.vpc_name
   cidr_private_subnet  = var.cidr_private_subnet
   cidr_public_subnet   = var.cidr_public_subnet
   availability_zone    = var.availability_zone
}

module "Security-Groups" {
  source               = "./Security-Groups"
  ec2_sg_name          = "SG for EC2 to enable SSH(22), HTTPS(443) and HTTP(80)"
  ec2_jenkins_sg_name  = "Allow port 5000"
  vpc_id               = module.Networking.vpc_id
}

module "EC2_instance" {
  source           = "./EC2_instance"
  instance_type    = "t2.micro"
  tag_name         = "Python_Flask_Deployment"
  ami_id           = "ami-036841078a4b68e14"
  public_key       = var.public_key
  subnet_id        = element(module.Networking.Public_Subnet_id,0)
  enable_public_ip_address  = true
  user_data_install_apache = templatefile("./template/ec2_install_apache.sh", {})
  vpc_security_group_ids    = [module.Security-Groups.ec2_sg_ssh_http_id, module.Security-Groups.Jenkins_SG_8080_id]
}

module "rds_db_instance" {
  source               = "./rds"
  db_subnet_group_name = "dev_proj_1_rds_subnet_group"
  subnet_groups        = tolist(module.Networking.Public_Subnet_id)
  rds_mysql_sg_id      = module.Security-Groups.RDS_3306_id
  mysql_db_identifier  = "mydb"
  mysql_username       = "dbuser"
  mysql_password       = "dbpassword"
  mysql_dbname         = "devprojdb"
}
