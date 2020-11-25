


module "MultiAZSubnet" {
	source				= "./module/MultiAZSubnet"
	common_tag_name		= 	var.common_tag_name
	vpc_cider_block		= 	var.vpc_cider_block
	availability_zone1	=	var.availability_zone1
	availability_zone2	=	var.availability_zone2
	vpc_publicsubnet1_block	= var.vpc_publicsubnet1_block
	vpc_publicsubnet2_block	= var.vpc_publicsubnet2_block
	vpc_privatesubnet1_block= var.vpc_privatesubnet1_block
	vpc_privatesubnet2_block= var.vpc_privatesubnet2_block
}







