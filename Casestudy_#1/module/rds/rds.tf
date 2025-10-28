# Call VPC Module First to get the subnet IDs
module "levelup-vpc" {
  source = "../vpc"

  ENVIRONMENT = var.ENVIRONMENT
  AWS_REGION = var.AWS_REGION
}

# Define Subnet Group for RDS Service
resource "aws_db_subnet_group" "levelup_rds_subnet_group" {
    
  name       = "${var.ENVIRONMENT}-levelup-db-subnet"
  description = "Allowed subnets for DB cluster instances"
  subnet_ids = [
    "${module.levelup-vpc.private_subnet1_id}",
    "${module.levelup-vpc.private_subnet2_id}"
  ]
  tags = {
        Name = "${var.ENVIRONMENT}-levelup-db-subnet-group"
  }
}

# Define the Security Group for RDS Instance
resource "aws_security_group" "levelup_rds_sg" {
  name        = "${var.ENVIRONMENT}-levelup-rds-sg"
  description = "Security group for LevelUp RDS instance"
  vpc_id      = module.levelup-vpc.my_vpc_id

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["${var.RDS_CIDR}"]
    }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.ENVIRONMENT}-levelup-rds-sg"
    }
}

# Create the RDS Instance
resource "aws_db_instance" "levelup_rds_instance" {
  identifier              = "${var.ENVIRONMENT}-levelup-rds-instance"
  allocated_storage       = var.LEVELUP_RDS_ALLOCATED_STORAGE
  storage_type            = "gp2"
  engine                  = var.LEVELUP_RDS_ENGINE
  engine_version          = var.LEVELUP_RDS_ENGINE_VERSION
  instance_class          = var.DB_INSTANCE_CLASS
  backup_retention_period = var.BACKUP_RETENTION_PERIOD
  publicly_accessible     = var.PUBLIC_ACCESSIBLE

  username                = var.LEVELUP_RDS_USERNAME
  password                = var.LEVELUP_RDS_PASSWORD
  
  vpc_security_group_ids  = [aws_security_group.levelup_rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.levelup_rds_subnet_group.name
  multi_az                = false
}

output "rds_prod_endpoint" {
    description = "RDS Production Endpoint"
    value       = aws_db_instance.levelup_rds_instance.endpoint
}