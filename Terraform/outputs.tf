# three-tier-architecture/outputs.tf
output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = module.application.alb_dns_name
}

output "db_endpoint" {
  description = "The endpoint of the RDS database."
  value       = module.database.db_endpoint
}