

variable "common_tag_name" {}


variable "availability_zone1" {
	default = "ap-northeast-1a"
}

variable "availability_zone2" {
	default = "ap-northeast-1c"
}


variable "vpc_cider_block" {}

variable "vpc_publicsubnet1_block" {}
variable "vpc_publicsubnet2_block" {}
variable "vpc_privatesubnet1_block" {}
variable "vpc_privatesubnet2_block" {}
variable "vpc_enable_dns_hostnames" { default = true }
