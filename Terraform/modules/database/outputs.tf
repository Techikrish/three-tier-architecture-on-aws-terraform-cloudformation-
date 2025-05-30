output "db_endpoint" {
  description = "The endpoint of the RDS database instance."
  value       = aws_db_instance.main.address
}