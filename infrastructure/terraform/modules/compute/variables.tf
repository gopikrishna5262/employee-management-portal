variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "app_sg_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "db_secret_arn" {
  type = string
}

variable "artifacts_bucket_arn" {
  description = "ARN of the S3 artifacts bucket"
  type = string
}

