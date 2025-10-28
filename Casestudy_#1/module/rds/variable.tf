variable "AWS_REGION" {
  type       = string
  default    = "us-east-2"
}

variable "BACKUP_RETENTION_PERIOD" {
  description = "The days to retain backups for RDS instance"
  type       = number
  default    = 7
}

variable "PUBLIC_ACCESSIBLE" {
  description = "Specifies whether the RDS instance is publicly accessible"
  type       = bool
  default    = true
}

variable "LEVELUP_RDS_USERNAME" {
  description = "The master username for the RDS instance"
  type       = string
  default    = "adminuser"
}

variable "LEVELUP_RDS_PASSWORD" {
  description = "The master password for the RDS instance"
  type       = string
  default    = "adminpassword"
}

variable "LEVELUP_RDS_ALLOCATED_STORAGE" {
  description = "The allocated storage in gigabytes for the RDS instance"
  type       = number
  default    = 20
}

variable "LEVELUP_RDS_ENGINE" {
  description = "The database engine for the RDS instance"
  type       = string
  default    = "mysql"
}

variable "LEVELUP_RDS_ENGINE_VERSION" {
  description = "The version of the database engine for the RDS instance"
  type       = string
  default    = "8.0.20"
}

variable "DB_INSTANCE_CLASS" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "db.t2.micro"
}

variable "RDS_CIDR" {
  description = "The CIDR block allowed to access the RDS instance"
  type       = string
  default    = "0.0.0.0/0"
}

variable "ENVIRONMENT" {
  description = "AWS RDS Environment Name"
  type       = string
  default    = "Development"
}
