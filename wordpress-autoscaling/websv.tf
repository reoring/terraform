
resource "aws_security_group" "WebSV" {
	name        = "${var.common_tag_name}-WebSV"
	description = "WebSV Securty Group"
	vpc_id      = module.MultiAZSubnet.vpc_id


	ingress {
		description = "http"
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		security_groups	= [aws_security_group.ALB.id]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "${var.common_tag_name}-WebSV"
	}
}



resource "aws_security_group" "EFS" {
	name        = "${var.common_tag_name}-EFS"
	description = "EFS Securty Group"
	vpc_id      = module.MultiAZSubnet.vpc_id


	ingress {
		description = "EFS"
		from_port   = 2049
		to_port     = 2049
		protocol    = "tcp"
		security_groups	= [aws_security_group.WebSV.id]
	}

	tags = {
		Name = "${var.common_tag_name}-EFS"
	}
}


resource "aws_efs_file_system" "default" {
	tags = {
		Name = var.common_tag_name
	}
}



resource "aws_efs_mount_target" "subnet1" {
	file_system_id	= aws_efs_file_system.default.id
	subnet_id		= module.MultiAZSubnet.Privatesubnet1_id
	security_groups	= [aws_security_group.EFS.id]
}


resource "aws_efs_mount_target" "subnet2" {
	file_system_id	= aws_efs_file_system.default.id
	subnet_id		= module.MultiAZSubnet.Privatesubnet2_id
	security_groups	= [aws_security_group.EFS.id]
}




data	"aws_ssm_parameter" "amazonlinux2" {
#	provider = aws.region-master
	name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}



data "template_file" "websv_user_data" {
	template = file("./websv_user_data.sh.tpl")

	vars = {
		region					= var.aws_region
		EFSFileSystem			= aws_efs_file_system.default.id
		RDSInstanceIdentifier	= aws_db_instance.default.id
		RDSMasterUserName		= aws_db_instance.default.username
		RDSMasterUserPW			= var.rds_password
		EndpointAddress			= aws_db_instance.default.endpoint
		WebSVALBDNSName			= aws_lb.default.dns_name
		WordPressTitle			= var.WordPressTitle
		WordPressAdminName		= var.WordPressAdminName
		WordPressAdminPassword	= var.WordPressAdminPassword
		WordPressAdminEmail		= var.WordPressAdminEmail
	}
}


resource "aws_launch_configuration" "default" {
	name_prefix				= var.common_tag_name
	image_id				= data.aws_ssm_parameter.amazonlinux2.value
	instance_type			= var.WebSVInstanceType
	iam_instance_profile	= var.WebSVIamInstanceProfile
	security_groups			= [aws_security_group.WebSV.id, module.MultiAZSubnet.vpc_default_security_group_id]
	key_name				= var.WevSVKeyName
	associate_public_ip_address	= false
	user_data					= data.template_file.websv_user_data.rendered
	lifecycle {
		create_before_destroy	= true
	}

}






resource "aws_autoscaling_group" "default" {
	desired_capacity   		= 1
	max_size           		= 1
	min_size           		= 1
	launch_configuration	= aws_launch_configuration.default.name
	vpc_zone_identifier		= [module.MultiAZSubnet.Privatesubnet1_id, module.MultiAZSubnet.Privatesubnet2_id]
	target_group_arns		= [aws_lb_target_group.default.arn]
	health_check_type		= var.autoscaling_health_check_type
	health_check_grace_period	= var.health_check_grace_period
	tags					= [
		{
		"key"					= "Name"
		"value"					= "${var.common_tag_name}-AutoScaling"
		"propagate_at_launch"	= true
		}
	]
}



resource "aws_autoscaling_policy" "default-cpu" {
	name					= var.common_tag_name
	adjustment_type			= "ChangeInCapacity"
	# cooldown				= var.autoscaling_policy_cooldown
	policy_type 			= "TargetTrackingScaling"
	autoscaling_group_name = aws_autoscaling_group.default.name
	target_tracking_configuration {
		predefined_metric_specification {
			predefined_metric_type = "ASGAverageCPUUtilization"
		}
		target_value = var.autoscaling_policy_target_value
	}
}
