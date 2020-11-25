variable "aws_region" {
  description = "AWS Region where the resources will be created"
  default     = "ap-northeast-1"
}




variable "common_tag_name" {
	default = "tftest"
}


variable "availability_zone1" {
	default = "ap-northeast-1a"
}

variable "availability_zone2" {
	default = "ap-northeast-1c"
}


variable "vpc_cider_block" {
	default = "172.1.0.0/16"
}


variable "vpc_publicsubnet1_block" {
	default = "172.1.10.0/24"
}

variable "vpc_publicsubnet2_block" {
	default = "172.1.20.0/24"
}


variable "vpc_privatesubnet1_block" {
	default = "172.1.1.0/24"
}

variable "vpc_privatesubnet2_block" {
	default = "172.1.2.0/24"
}


variable "rds_allocated_storage" {
	default = 20
}

variable "rds_engine" {
	default = "mysql"
}

variable "rds_engine_version" {
	default = 5.7
}

variable "rds_instance_class" {
	default = "db.t3.micro"
}

variable "rds_dbname" {
	default = "mydb"
}

variable "rds_username" {
	default = "root"
}

variable "rds_password" {
	default = "rdspassword"
}


variable "WebSVIamInstanceProfile" {
	default = "EC2CustomRole"
}

variable "WebSVInstanceType" {
	default = "t3a.micro"
}


variable "WevSVKeyName" {
	default = "WordPressKey"
}

variable "WordPressTitle" {
	default = "wp_title"
}

variable "WordPressAdminName" {
	default = "WPAdmin"
}

variable "WordPressAdminPassword" {
	default = "WPAdminPassword"
}

variable "WordPressAdminEmail" {
	default = "xxxxxx@xxx.co.jp"
}


variable "autoscaling_health_check_type" {
	default = "EC2"
}

variable "health_check_grace_period" {
	default = 300
}



variable "autoscaling_policy_cooldown" {
	default = 300
}


variable "autoscaling_policy_target_value" {
	default = 40
}


provider "aws" {
	region = var.aws_region
}
