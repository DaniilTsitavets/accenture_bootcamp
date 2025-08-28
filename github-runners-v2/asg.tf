resource "aws_launch_template" "runner" {
  name_prefix   = "${var.environment}-${var.prefix}-lt"
  image_id      = data.aws_ami.al2023.id
  instance_type = var.instance_type

  iam_instance_profile { 
		name = aws_iam_instance_profile.runners_ec2_profile.name 
	}

	network_interfaces {
    security_groups             = [aws_security_group.runner.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 16
      volume_type           = "gp3"
      delete_on_termination = true
			encrypted  = true
    }
  }

  user_data = base64encode(
  	templatefile("./scripts/user_data.sh", {
			GH_OWNER       = var.github_owner
			GH_REPO        = var.github_repo
			GH_LABELS      = var.runner_labels
			REGION         = var.aws_region
			SSM_PARAM_NAME = var.github_pat_ssm_parameter_name
			NAME_PREFIX    = var.runner_prefix
			EPHEMERAL      = var.ephemeral ? "true" : "false"
		})
	)
}

resource "aws_autoscaling_group" "runner" {
  name             = "${var.environment}-${var.prefix}-asg"
  max_size         = 1
  min_size         = 1
  desired_capacity = 1
  vpc_zone_identifier = local.subnet_ids_unique

  launch_template {
    id      = aws_launch_template.runner.id
  }

  health_check_type         = "EC2"
  health_check_grace_period = 60
  termination_policies      = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "${var.environment}-${var.prefix}"
    propagate_at_launch = true
  }
}