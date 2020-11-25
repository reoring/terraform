
resource "aws_security_group" "Bastion" {
	name        = "${var.common_tag_name}-Bastion"
	description = "Bastion Securty Group"
	vpc_id      = module.MultiAZSubnet.vpc_id


	ingress {
		description = "RDP"
		from_port   = 3389
		to_port     = 3389
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "${var.common_tag_name}-Bastion"
	}
}



data	"aws_ssm_parameter" "windows2019" {
	name     = "/aws/service/ami-windows-latest/Windows_Server-2019-Japanese-Full-Base"
}




resource "aws_instance" "bastion" {
	ami				= data.aws_ssm_parameter.windows2019.value
	instance_type	= "t3a.medium"
	key_name		= var.WevSVKeyName
	security_groups	= [aws_security_group.Bastion.id, module.MultiAZSubnet.vpc_default_security_group_id]
	subnet_id		= module.MultiAZSubnet.Publicsubnet1_id
	tags = {
		Name = "${var.common_tag_name}-bastion"
	}
}
