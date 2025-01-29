# Configure Application Load Balancer
resource "aws_lb" "alb" {
  name               = "alb-tf"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.sg-for-alb.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  tags               = merge(local.project-tag, { Name = "myALB-${local.project-tag["project"]}" })

}
resource "aws_lb_target_group" "alb-tg" {
  name        = "tf-lb-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.myvpc.id
  tags        = merge(local.project-tag, { Name = "myAlbTG-${local.project-tag["project"]}" })

}

resource "aws_lb_listener" "webtier_lb-listner" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
  tags = merge(local.project-tag, { Name = "alblistner-${local.project-tag["project"]}" })
}