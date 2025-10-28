module "levelup-vpc" {
  source = "../module/vpc"

  ENVIRONMENT = var.ENVIRONMENT
  AWS_REGION  = var.AWS_REGION
}

module "levelup-rds" {
  source = "../module/rds"

  ENVIRONMENT = var.ENVIRONMENT
  AWS_REGION  = var.AWS_REGION
}

resource "aws_security_group" "levelup_webservers" {
  tags = {
    Name = "${var.ENVIRONMENT}-levelup-webservers"
  }

  name          = "${var.ENVIRONMENT}-levelup-webservers"
  description   = "Security group for LevelUp webserver instances"
  vpc_id        = module.levelup-vpc.my_vpc_id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${var.SSH_CIDR_WEB_SERVER}"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Resource Key pair for webserver instances
resource "aws_key_pair" "levelup_webserver_keypair" {
  key_name   = "levelup_key"
  public_key = file(var.PUBLIC_KEY_PATH)
}

resource "aws_launch_configuration" "launch_config_webserver" {
    name = "launch-config-webserver"
    image_id = lookup(var.AMIS, var.AWS_REGION)
    instance_type = var.INSTANCE_TYPE
    user_data = file("./webserver/user_data.sh")
    security_groups = [aws_security_group.levelup_webservers.id]
    key_name = aws_key_pair.levelup_webserver_keypair.key_name

    root_block_device {
      volume_type = "gp3"
      volume_size = "20"
    }
  
}

resource "aws_autoscaling_group" "levelup_webserver" {
  name = "levelup-webservers"
  max_size = 2
    min_size = 1
    health_check_grace_period = 30
    health_check_type = "EC2"
    desired_capacity = 1
    launch_configuration = aws_launch_configuration.launch_config_webserver.name
    vpc_zone_identifier = ["${module.levelup-vpc.public_subnet1_id}", "${module.levelup-vpc.public_subnet2_id}"]
    target_group_arns = [aws_lb_target_group.load-balancer-target-group.arn]
}

# Application Load Balancer for app server
resource "aws_lb" "levelup_load_balancer" {
    name = "${var.ENVIRONMENT}-levelup-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.levelup_webservers_alb.id]
    subnets = ["${module.levelup-vpc.public_subnet1_id}", "${module.levelup-vpc.public_subnet2_id}"]
}

# Adding Target Group for Load Balancer
resource "aws_lb_target_group" "load-balancer-target-group" {
    name = "load-balancer-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = module.levelup-vpc.my_vpc_id
}

# Adding Http Listener for Load Balancer
resource "aws_lb_listener" "webserver_listener" {
    load_balancer_arn = aws_lb.levelup_load_balancer.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.load-balancer-target-group.arn
    }
}

output "load_balancer_output" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.levelup_load_balancer.dns_name
}