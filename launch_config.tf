resource "aws_launch_configuration" "web" {
  name_prefix     = "web-"
  image_id        = var.ami_ubuntu
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.demosg1.id]
  lifecycle {
    create_before_destroy = true
  }
}
