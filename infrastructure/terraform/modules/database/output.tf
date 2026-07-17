output "secret_arn" {
  value = aws_secretsmanager_secret.db.arn
}

output "endpoint" {
  value = aws_db_instance.this.address
}

output "db_identifier" {
  value = aws_db_instance.this.id
}