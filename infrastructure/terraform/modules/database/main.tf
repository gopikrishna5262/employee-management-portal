resource "random_password" "db" {
  length  = 20
  special = false
}

resource "aws_secretsmanager_secret" "db" {
  name = "${var.environment}/empportal/db"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db.result
    host     = aws_db_instance.this.address
    port     = 3306
    dbname   = var.db_name
  })
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-db-subnet"
  subnet_ids = var.private_subnet_ids
}

resource "aws_db_instance" "this" {
  identifier             = "${var.environment}-empportal-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class   # db.t3.micro — free-tier eligible
  allocated_storage      = 20                        # free tier covers up to 20GB
  db_name                = var.db_name
  username               = var.db_username
  password               = random_password.db.result
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_sg_id]
  multi_az               = false   # free-tier: single-AZ everywhere, even prod
  backup_retention_period = 1      # keep low; free tier includes 20GB backup storage
  skip_final_snapshot    = true
  deletion_protection    = false   # so `terraform destroy` works cleanly for qa/prod teardown
  publicly_accessible    = false
  storage_encrypted      = true
}