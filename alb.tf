resource "aws_lb" "alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = [aws_subnet.subnet_public_1.id, aws_subnet.subnet_public_2.id]
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "${var.project_name}-alb-tg"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
}

resource "aws_alb_target_group_attachment" "alp_attachment_1" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.instance_1.id
}

resource "aws_alb_target_group_attachment" "alp_attachment_2" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.instance_2.id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}