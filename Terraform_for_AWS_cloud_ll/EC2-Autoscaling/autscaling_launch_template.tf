# Key Pair
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2b"
}


# Launch Template
resource "aws_launch_template" "launch_template" {
  name_prefix   = "Launch-template-"
  image_id      = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name

  network_interfaces {
    associate_public_ip_address = true
    #security_groups             = [aws_security_group.example.id]  # Replace with actual SG
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "AutoScalingInstance"
    }
  }
}



# Autoscaling Group
resource "aws_autoscaling_group" "AutoScalingGroup" {
  name                  = "AutoScalingGroup"
  min_size              = 1
  max_size              = 3
  health_check_grace_period = 200
  health_check_type     = "EC2"
  force_delete          = true
  vpc_zone_identifier   = [aws_subnet.subnet1.id,aws_subnet.subnet2.id] # Replace accordingly

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "AutoScalingInstance"
    propagate_at_launch = true
  }
}

# Scaling Up Policy
resource "aws_autoscaling_policy" "AutoScalingPolicy" {
  name                   = "AutoScalingPolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 200
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.AutoScalingGroup.name
}

# Scale Up Alarm
resource "aws_cloudwatch_metric_alarm" "AutoScalingAlarm" {
  alarm_name          = "AutoScalingAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.AutoScalingGroup.name
  }

  alarm_description = "Monitors CPU for Auto Scaling group."
  actions_enabled   = true
  alarm_actions     = [aws_autoscaling_policy.AutoScalingPolicy.arn]
}

# Scaling Down Policy
resource "aws_autoscaling_policy" "AutoDeScalingPolicy" {
  name                   = "AutoDeScalingPolicy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 200
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.AutoScalingGroup.name
}

# Scale Down Alarm
resource "aws_cloudwatch_metric_alarm" "AutoDeScalingAlarm" {
  alarm_name          = "AutoDeScalingAlarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10 
    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.AutoScalingGroup.name
    }
    alarm_description = "Monitors CPU for Auto Scaling group."
    actions_enabled   = true
    alarm_actions     = [aws_autoscaling_policy.AutoDeScalingPolicy.arn]
}