variable "aws_region" {
  description = "AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "A unique name for your project, used for resource naming and tagging."
  type        = string
  default     = "three-tier-app"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the main VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets (e.g., for ALB)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "app_subnet_cidrs" {
  description = "List of CIDR blocks for application private subnets."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "db_subnet_cidrs" {
  description = "List of CIDR blocks for database private subnets."
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones to use."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"] # Adjust based on your region
}

variable "ami_id" {
  description = "AMI ID for the application EC2 instances (e.g., Amazon Linux 2)."
  type        = string
  default = "ami-0953476d60561c955" # Replace with a valid AMI for your region!
}

variable "instance_type" {
  description = "EC2 instance type for application servers."
  type        = string
  default     = "t2.micro"
}

variable "app_min_size" {
  description = "Minimum number of application instances."
  type        = number
  default     = 1
}

variable "app_max_size" {
  description = "Maximum number of application instances."
  type        = number
  default     = 2
}

variable "app_desired_capacity" {
  description = "Desired number of application instances."
  type        = number
  default     = 1
}

variable "db_allocated_storage" {
  description = "Allocated storage for the RDS instance in GB."
  type        = number
  default     = 20
}

variable "db_engine" {
  description = "Database engine for RDS."
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version for RDS."
  type        = string
  default     = "5.7" 
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Name of the database within RDS."
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "Master username for the RDS database."
  type        = string
  sensitive   = true
  default     = "admin"
}

variable "db_password" {
  description = "Master password for the RDS database."
  type        = string
  sensitive   = true
  default     = "MyStrongPassword123" 
}

variable "db_multi_az" {
  description = "Whether to deploy the RDS instance in a Multi-AZ configuration."
  type        = bool
  default     = false
}