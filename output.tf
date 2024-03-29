output "aws_ami_id" {
  value       = data.aws_ami.ec2_linux.id
  description = "The ID of the AWS Linux AMI, used by the Bastion Hosts."
}

output "utility_hosts_sg" {
  value       = aws_security_group.utility_hosts.id
  description = "The SG that utility boxes are assigned enabling SSH."
}

output "allow_utility_access_sg" {
  value       = aws_security_group.allow_utility_access.id
  description = "Assign this SG to boxes you wish to be accessible from utilities."
}

output "public_subnets" {
  value       = aws_subnet.public_subnets.*.id
  description = "Public subnet IDs configured with a cooresponding private subnet."
}

output "utility_subnet_id" {
  value       = aws_subnet.utility_subnet.id
  description = "The utility subnet ID."
}

output "private_subnets" {
  value       = aws_subnet.private_subnets.*.id
  description = "Private subnet IDs configured with a corresponding public subnet."
}

output "addl_private_subnets" {
  value       = aws_subnet.addl_private_subnets.*.id
  description = "Subnets configured with no public pairs. This doesn't mean they don't have a corresponding public subnet."
}

output "bastion_host_ids" {
  value       = aws_instance.bastion_hosts.*.id
  description = "A list of ids for your bastion hosts."
}

output "bastion_host_public_ips" {
  value       = local.enable_single_bastion_eip ? [aws_eip.single_bastion_eip[0].public_ip] : aws_instance.bastion_hosts.*.public_ip
  description = "A list of public IP addresses for your bastion hosts."
}

output "bastion_host_private_ips" {
  value       = local.enable_single_bastion_eip ? [aws_eip.single_bastion_eip[0].private_ip] : aws_instance.bastion_hosts.*.private_ip
  description = "A list of private IP addresses for your bastion hosts."
}

output "vpc_id" {
  value       = aws_vpc.primary_vpc.id
  description = "The ID of the primary AWS VPC."
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.igw.id
  description = "The ID of the Internet Gateway."
}

output "nat_eip" {
  value       = aws_eip.nat_ip.public_ip
  description = "The Public IP of the NAT EIP."
}

output "nat_gateway_id" {
  value       = aws_nat_gateway.nat_gw.id
  description = "The ID of the NAT Gateway."
}

output "public_route_table_id" {
  value       = aws_route_table.public_route_table.id
  description = "The ID of the public route table."
}

output "private_route_table_id" {
  value       = aws_route_table.private_route_table.id
  description = "The ID of the private route table."
}

output "bastion_instance_role_name" {
  value       = aws_iam_role.bastion_role.name
  description = "The ID for the role that grants the bastion instance AWS permissions."
}
