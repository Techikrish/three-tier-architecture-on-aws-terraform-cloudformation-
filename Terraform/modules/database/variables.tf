# three-tier-architecture/modules/database/variables.tf (Corrected - REMOVE app_security_group_id)
variable "project_name" {
  description = "Name of the project for tagging resources."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "database_subnet_ids" {
  description = "List of database subnet IDs for RDS."
  type        = list(string)
}

variable "rds_security_group_id" {
  description = "The ID of the RDS security group."
  type        = string
}

# REMOVED: variable "app_security_group_id" - IT IS NO LONGER AN INPUT TO THIS MODULE

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes."
  type        = number
  default     = 20
}

variable "db_engine" {
  description = "The database engine to use."
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "The database engine version."
  type        = string
  default     = "5.7"
}

variable "db_instance_class" {
  description = "The EC2 instance type for the database."
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database to create."
  type        = string
}

variable "db_username" {
  description = "The master username for the database."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The master password for the database."
  type        = string
  sensitive   = true
}

variable "db_multi_az" {
  description = "Specifies if the RDS instance is deployed in a Multi-AZ configuration."
  type        = bool
  default     = false
}