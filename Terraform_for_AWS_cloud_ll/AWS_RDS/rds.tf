#RDS Resources

resource "aws_db_subnet_group" "mariadb-subnets" {
  name      = "mariadb-subnets"
  subnet_ids = [aws_subnet.levelupvpc-private-1.id, aws_subnet.levelupvpc-private-2.id]
  description = "Subnet group for MariaDB RDS instance"
}

#RDS Parameters

resource "aws_db_parameter_group" "mariadb-params" {
  name        = "mariadb-params"
  family      = "mariadb10.5"
  description = "Parameter group for MariaDB RDS instance"

  parameter {
    name  = "max_connections"
    value = "1000"
  }
}

#RDS Instance properties

resource "aws_db_instance" "mariadb-instance" {
  identifier              = "mariadb-instance"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mariadb"
  engine_version          = "10.5"
  instance_class          = "db.t2.micro"
  db_subnet_group_name    = aws_db_subnet_group.mariadb-subnets.name
  vpc_security_group_ids  = [aws_security_group.allow-mariadb.id]
  parameter_group_name    = aws_db_parameter_group.mariadb-params.name
  username                = "admin"
  password                = "admin" # Change this to a secure password
  skip_final_snapshot     = true
  availability_zone       = aws_subnet.levelupvpc-private-1.availability_zone
  backup_retention_period = 30
  

  tags = {
    Name = "mariadb-instance"
  }
}

output "rds"{
    value = aws_db_instance.mariadb-instance.endpoint
}