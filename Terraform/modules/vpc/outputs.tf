# three-tier-architecture/modules/vpc/outputs.tf
output "vpc_id" {
  description = "The ID of the created VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of IDs of the public subnets."
  value       = [for s in aws_subnet.public : s.id]
}

output "application_subnet_ids" {
  description = "List of IDs of the application subnets."
  value       = [for s in aws_subnet.application : s.id]
}

output "database_subnet_ids" {
  description = "List of IDs of the database subnets."
  value       = [for s in aws_subnet.database : s.id]
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC."
  value       = aws_vpc.main.cidr_block
}