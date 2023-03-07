resource "aws_security_group" "web" {
  name        = "WEB security group"
  description = "WEB security group"
  vpc_id      = aws_vpc.vpc.id

  egress {
    description = "allow all outbound traffic"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    description = "allow icmp for my IP addresses"
    cidr_blocks = var.admin_ips
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
  }

  ingress {
    description = "allow ssh for my IP addresses"
    cidr_blocks = var.admin_ips
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
  }

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      description = "allow ${ingress.value} port for my IP addresses"
      cidr_blocks = var.allow_ips
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
    }
  }
}