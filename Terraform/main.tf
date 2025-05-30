provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
  app_subnet_cidrs   = var.app_subnet_cidrs
  db_subnet_cidrs    = var.db_subnet_cidrs
  availability_zones = var.availability_zones
}

resource "aws_security_group" "alb" {
  name_prefix = "${var.project_name}-alb-sg-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

resource "aws_security_group" "app_servers" {
  name_prefix = "${var.project_name}-app-sg-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id] # Allow traffic from ALB
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  tags = {
    Name = "${var.project_name}-app-sg"
  }
}

resource "aws_security_group" "rds" {
  name_prefix = "${var.project_name}-rds-sg-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306 # MySQL port
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_servers.id] # Allow traffic from application servers SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}


module "database" {
  source = "./modules/database"

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  database_subnet_ids   = module.vpc.database_subnet_ids
  
  rds_security_group_id = aws_security_group.rds.id
  

  db_allocated_storage  = var.db_allocated_storage
  db_engine             = var.db_engine
  db_engine_version     = var.db_engine_version
  db_instance_class     = var.db_instance_class
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  db_multi_az           = var.db_multi_az
}

module "application" {
  source = "./modules/application"

  project_name           = var.project_name
  vpc_id                 = module.vpc.vpc_id
  public_subnet_ids      = module.vpc.public_subnet_ids
  application_subnet_ids = module.vpc.application_subnet_ids
  alb_security_group_id  = aws_security_group.alb.id
  app_security_group_id  = aws_security_group.app_servers.id
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  min_size               = var.app_min_size
  max_size               = var.app_max_size
  desired_capacity       = var.app_desired_capacity
  db_endpoint            = module.database.db_endpoint
  db_username            = var.db_username
  db_password            = var.db_password
  db_name                = var.db_name
}