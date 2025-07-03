# AutoScaling Launch Configuration

resource "aws_launch_configuration" "Launch-config" {
  name_prefix          = "Launch-config"
  image_id             = lookup(var.AMIS,var.AWS_REGION) # Replace with a valid AMI ID
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.levelup_key.key_name

}

resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# Autoscaling Group

resource "aws_autoscaling_group" "AutoScalingGroup" {
  name                 = "AutoScalingGroup"
  launch_configuration = aws_launch_configuration.Launch-config.name
  min_size             = 1
  max_size             = 3
  health_check_grace_period = 200
  health_check_type   = "EC2"
  force_delete = true
  vpc_zone_identifier = ["us-east-2b","us-east-2a"] # Replace with your subnet ID

  tag {
    key                 = "Name"
    value               = "AutoScalingInstance"
    propagate_at_launch = true
  }
}

# Autoscaling Config Policy

resource "aws_autoscaling_policy" "AutoScalingPolicy" {
  name                   = "AutoScalingPolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 200
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.AutoScalingGroup.name
}

# AutoScaling CloudWatch Monitoring

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

  alarm_description = "This metric monitors CPU utilization for the Auto Scaling group."
  
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.AutoScalingPolicy.arn]
}

# AutoDeScaling Policy

resource "aws_autoscaling_policy" "AutoDeScalingPolicy" {
  name                   = "AutoDeScalingPolicy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 200
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.AutoScalingGroup.name
}

# AutoDeScaling CloudWatch Monitoring

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

  alarm_description = "This metric monitors CPU utilization for the Auto Scaling group."
  
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.AutoDeScalingPolicy.arn]
}



