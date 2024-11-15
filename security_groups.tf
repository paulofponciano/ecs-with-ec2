resource "aws_security_group" "ec2" {
  name        = "${var.namespace}_EC2_Instance_SecurityGroup_${var.environment}"
  description = "Security group for EC2 instances in ECS cluster"
  vpc_id      = aws_vpc.default.id

  ingress {
    description     = "Allow ingress traffic from ALB on HTTP on ephemeral ports"
    from_port       = 1024
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "${var.namespace}_EC2_Instance_SecurityGroup_${var.environment}"
    Project = var.project
    Terraform = true
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.namespace}_ALB_SecurityGroup_${var.environment}"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.default.id

  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "${var.namespace}_ALB_SecurityGroup_${var.environment}"
    Project = var.project
    Terraform = true
  }
}

resource "aws_security_group_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTPS access"
  from_port         = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP access"
  from_port         = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 80
  type              = "ingress"
}