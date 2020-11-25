

output "vpc_arn" {
	value = aws_vpc.Common.arn
}

output "vpc_id" {
	value = aws_vpc.Common.id
}

output "vpc_default_security_group_id" {
	value = aws_vpc.Common.default_security_group_id
}

output "vpc_default_route_table_id" {
	value = aws_vpc.Common.default_route_table_id
}

output "internet_gateway_arn" {
	value = aws_internet_gateway.Common.arn
}

output "internet_gateway_id" {
	value = aws_internet_gateway.Common.id
}

output "internet_gateway_owner_id" {
	value = aws_internet_gateway.Common.owner_id
}



output "PublicSubnet1_arn" {
	value = aws_subnet.Public_Subnet1.arn
}

output "Publicsubnet1_id" {
	value = aws_subnet.Public_Subnet1.id
}

output "Publicsubnet1_owner_id" {
	value = aws_subnet.Public_Subnet1.owner_id
}

output "PublicSubnet2_arn" {
	value = aws_subnet.Public_Subnet2.arn
}

output "Publicsubnet2_id" {
	value = aws_subnet.Public_Subnet2.id
}

output "Publicsubnet2_owner_id" {
	value = aws_subnet.Public_Subnet2.owner_id
}



output "PrivateSubnet1_arn" {
	value = aws_subnet.Private_Subnet1.arn
}

output "Privatesubnet1_id" {
	value = aws_subnet.Private_Subnet1.id
}

output "Privatesubnet1_owner_id" {
	value = aws_subnet.Private_Subnet1.owner_id
}

output "PrivateSubnet2_arn" {
	value = aws_subnet.Private_Subnet2.arn
}

output "Privatesubnet2_id" {
	value = aws_subnet.Private_Subnet2.id
}

output "Privatesubnet2_owner_id" {
	value = aws_subnet.Private_Subnet2.owner_id
}

output "nat_gateway_id" {
	value = aws_nat_gateway.Common.id
}

output "nat_gateway_allocation_id" {
	value = aws_nat_gateway.Common.allocation_id
}

output "nat_gateway_public_ip" {
	value = aws_nat_gateway.Common.public_ip
}
