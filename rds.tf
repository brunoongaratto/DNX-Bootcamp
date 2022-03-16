# Create subnet group
resource "aws_db_subnet_group" "rds" {
  name       = "main"
  subnet_ids = [aws_subnet.privatesubnets.id, aws_subnet.privatesubnets2.id]
  tags = {
    Name = "Final challenge DB subnet group"
  }
}
#RDS DB option group
resource "aws_db_option_group" "rds" {
  name                     = "optiongroup-mentorship"
  option_group_description = "Terraform Option Group"
  engine_name              = "mysql"
  major_engine_version     = "5.7"
  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
    option_settings {
      name  = "SERVER_AUDIT_EVENTS"
      value = "CONNECT"
    }
    option_settings {
      name  = "SERVER_AUDIT_FILE_ROTATIONS"
      value = "37"
    }
  }
}

# Create DB parameter group
resource "aws_db_parameter_group" "rds" {
  name   = "rdsmysql"
  family = "mysql5.7"
  parameter {
    name  = "autocommit"
    value = "1"
  }
  parameter {
    name  = "binlog_error_action"
    value = "IGNORE_ERROR"
  }
}

# Create RDS DB Instance
resource "aws_db_instance" "rds" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7.19"
  instance_class         = "db.t2.micro"
  name                   = "mydb"
  username               = var.database_user
  password               = var.database_password
  db_subnet_group_name   = aws_db_subnet_group.rds.id
  option_group_name      = aws_db_option_group.rds.id
  publicly_accessible    = "false"
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.rds.id
  skip_final_snapshot    = true
  port                   = 3306
  tags = {
    Name = "Final_challenge_DB_RDS"
  }
}
