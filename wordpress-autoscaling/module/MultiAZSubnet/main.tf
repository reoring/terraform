
##########################################
######		VPC		
##########################################
resource "aws_vpc" "Common" {
	cidr_block       = var.vpc_cider_block
	enable_dns_hostnames = var.vpc_enable_dns_hostnames
	tags = {
		Name = var.common_tag_name
	}
}


##########################################
######		InternetGateway
##########################################
resource "aws_internet_gateway" "Common" {
	vpc_id				= aws_vpc.Common.id
	tags = {
		Name = var.common_tag_name
	}
}



##########################################
######		NatGateway
##########################################

resource "aws_eip" "Common" {
	vpc = true

	tags = {
		Name = var.common_tag_name
	}
}

resource "aws_nat_gateway" "Common" {
	allocation_id = aws_eip.Common.id
	subnet_id     = aws_subnet.Public_Subnet1.id

	tags = {
		Name = var.common_tag_name
	}
}




##########################################
######		PublicSubnet
##########################################
resource "aws_subnet" "Public_Subnet1" {
	vpc_id				= aws_vpc.Common.id
	availability_zone	= var.availability_zone1
	cidr_block			= var.vpc_publicsubnet1_block
	map_public_ip_on_launch	= true
	tags = {
		Name = "${var.common_tag_name}-Public_Subnet1"
	}
}

resource "aws_subnet" "Public_Subnet2" {
	vpc_id				= aws_vpc.Common.id
	availability_zone	= var.availability_zone2
	cidr_block			= var.vpc_publicsubnet2_block
	map_public_ip_on_launch	= true
	tags = {
		Name = "${var.common_tag_name}-Public_Subnet2"
	}
}


resource "aws_route_table" "public" {
	vpc_id				= aws_vpc.Common.id

	tags = {
		Name = "${var.common_tag_name}-Public"
	}
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.Common.id
}

resource "aws_route_table_association" "public_1" {
	subnet_id      = aws_subnet.Public_Subnet1.id
	route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
	subnet_id      = aws_subnet.Public_Subnet2.id
	route_table_id = aws_route_table.public.id
}





##########################################
######		PrivateSubnet
##########################################
resource "aws_subnet" "Private_Subnet1" {
	vpc_id				= aws_vpc.Common.id
	availability_zone	= var.availability_zone1
	cidr_block			= var.vpc_privatesubnet1_block
	map_public_ip_on_launch	= false
	tags = {
		Name = "${var.common_tag_name}-Private_Subnet1"
	}
}

resource "aws_subnet" "Private_Subnet2" {
	vpc_id				= aws_vpc.Common.id
	availability_zone	= var.availability_zone2
	cidr_block			= var.vpc_privatesubnet2_block
	map_public_ip_on_launch	= false
	tags = {
		Name = "${var.common_tag_name}-Private_Subnet2"
	}
}


resource "aws_route_table" "private" {
	vpc_id				= aws_vpc.Common.id

	tags = {
		Name = var.common_tag_name
	}
}

resource "aws_route" "private1" {
	destination_cidr_block = "0.0.0.0/0"
	route_table_id         = aws_route_table.private.id
	nat_gateway_id         = aws_nat_gateway.Common.id
}

resource "aws_route_table_association" "private_1" {
	subnet_id      = aws_subnet.Private_Subnet1.id
	route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
	subnet_id      = aws_subnet.Private_Subnet2.id
	route_table_id = aws_route_table.private.id
}

