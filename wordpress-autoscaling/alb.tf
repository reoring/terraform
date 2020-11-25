
resource "aws_security_group" "ALB" {
	name        = "${var.common_tag_name}-ALB"
	description = "ALB Securty Group"
	vpc_id      = module.MultiAZSubnet.vpc_id

	ingress {
		description = "https"
		from_port   = 443
		to_port     = 443
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		description = "http"
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "${var.common_tag_name}-ALB"
	}
}




resource "aws_lb" "default" {
	name				= var.common_tag_name
	internal			= false
	load_balancer_type = "application"
	security_groups    = [aws_security_group.ALB.id]
	subnets            = [module.MultiAZSubnet.Publicsubnet1_id,module.MultiAZSubnet.Publicsubnet2_id]

	tags = {
		Name = var.common_tag_name
	}
}


resource "aws_lb_target_group" "default" {
	name     = var.common_tag_name
	port     = 80
	protocol = "HTTP"
	vpc_id   = module.MultiAZSubnet.vpc_id
}

resource "aws_lb_listener" "default" {
	load_balancer_arn = aws_lb.default.arn
	port              = "80"
	protocol          = "HTTP"
	default_action {
		type             = "forward"
		target_group_arn = aws_lb_target_group.default.arn
	}
}

