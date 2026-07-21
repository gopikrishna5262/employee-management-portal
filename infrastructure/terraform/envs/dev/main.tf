module "network" {
  source      = "../../modules/network"
  vpc_cidr    = var.vpc_cidr
  environment = var.environment
}

module "security" {
  source      = "../../modules/security"
  vpc_id      = module.network.vpc_id
  environment = var.environment
}

module "database" {
  source             = "../../modules/database"
  environment        = var.environment
  private_subnet_ids = module.network.private_subnet_ids
  db_sg_id           = module.security.db_sg_id
  db_instance_class  = var.db_instance_class
  db_name            = var.db_name
  db_username        = var.db_username
}

module "compute" {
  source               = "../../modules/compute"
  environment          = var.environment
  vpc_id               = module.network.vpc_id
  public_subnet_ids    = module.network.public_subnet_ids
  app_sg_id            = module.security.app_sg_id
  instance_type        = var.instance_type
  db_secret_arn        = module.database.secret_arn
  artifacts_bucket_arn = module.storage.artifacts_bucket_arn
}

module "monitoring" {
  source        = "../../modules/monitoring"
  environment   = var.environment
  instance_id   = module.compute.instance_id
  db_identifier = module.database.db_identifier
  alert_email   = var.alert_email
}

module "storage" {
  source      = "../../modules/s3"
  environment = var.environment
}