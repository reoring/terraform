

resource "aws_security_group" "DB" {
	name        = "${var.common_tag_name}-DB"
	description = "DB Securty Group"
	vpc_id      = module.MultiAZSubnet.vpc_id


	ingress {
		description = "DB"
		from_port   = 3306
		to_port     = 3306
		protocol    = "tcp"
		security_groups	= [aws_security_group.WebSV.id]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "${var.common_tag_name}-DB"
	}
}


resource "aws_db_subnet_group" "default" {
	name       = var.common_tag_name
	subnet_ids = [module.MultiAZSubnet.Privatesubnet1_id, module.MultiAZSubnet.Privatesubnet2_id]

	tags = {
		Name = var.common_tag_name
	}
}



resource "aws_db_instance" "default" {
	allocated_storage		= var.rds_allocated_storage
	storage_type			= "gp2"
	engine					= var.rds_engine
	engine_version			= var.rds_engine_version
	instance_class			= var.rds_instance_class
	db_subnet_group_name	= aws_db_subnet_group.default.id
	vpc_security_group_ids	= [aws_security_group.DB.id]
	identifier				= var.common_tag_name
	name					= var.rds_dbname
	username				= var.rds_username
	password				= var.rds_password
#	parameter_group_name = "default.mysql5.7"
}






