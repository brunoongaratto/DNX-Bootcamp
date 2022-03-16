resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [
    aws_security_group.demosg1.id
  ]
  subnets = [
    aws_subnet.publicsubnets.id,
    aws_subnet.publicsubnets2.id
  ]
  cross_zone_load_balancing = true

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }
}

# Create Target group
resource "aws_lb_target_group" "final-challenge-target-group" {
  name     = "final-challenge-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.network.id
  target_type = "instance"
}
