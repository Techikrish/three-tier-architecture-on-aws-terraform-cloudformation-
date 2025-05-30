variable "project_name" {
  description = "Name of the project for tagging resources."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB."
  type        = list(string)
}

variable "application_subnet_ids" {
  description = "List of application subnet IDs for EC2 instances."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "The ID of the ALB security group."
  type        = string
}

variable "app_security_group_id" {
  description = "The ID of the application security group."
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group."
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group."
  type        = number
  default     = 1
}

variable "db_endpoint" {
  description = "The endpoint of the RDS database."
  type        = string
}

variable "db_username" {
  description = "Database username."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database password."
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name."
  type        = string
}