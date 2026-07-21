variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "The AWS Region where resources will be deployed."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "The deployment environment name (e.g., dev, qa, prod)."
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC network."

  # Modern best practice: Validate the CIDR format before running terraform apply
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "The vpc_cidr value must be a valid IPv4 CIDR address block."
  }
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "The EC2 instance type. Default is free-tier eligible."
}

variable "db_instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "The database instance class. Default is free-tier eligible."
}

variable "db_name" {
  type        = string
  default     = "empportal"
  description = "The name of the database to create."
}

variable "db_username" {
  type        = string
  default     = "empadmin"
  description = "The master username for the database."
}

variable "alert_email" {
  type        = string
  description = "The email address to receive monitoring and budget alerts."

  # Modern best practice: Basic regex validation for the email format
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.alert_email))
    error_message = "The alert_email variable must be a valid email address."
  }
}
