# Create RDS Security Group
resource "aws_security_group" "rds" {
  name        = "Final_challenge_DB_security_group" #security group name
  description = "SSH to the MySQL"
  vpc_id      = aws_vpc.network.id
  ingress {
    description = "ssh"
    security_groups= [aws_security_group.demosg1.id] #Launch configuration SG
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    description = "MYSQL"
    security_groups= [aws_security_group.demosg1.id]
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Final_challenge_DB_security_group"
  }
}