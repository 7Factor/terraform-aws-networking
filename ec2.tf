data "aws_ami" "ec2_linux" {
  most_recent = true
  owners      = [137112412989]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_instance" "bastion_hosts" {
  count                = var.bastion_count
  ami                  = data.aws_ami.ec2_linux.id
  instance_type        = var.bastion_instance_type
  subnet_id            = aws_subnet.utility_subnet.id
  iam_instance_profile = aws_iam_instance_profile.bastion_profile.id
  key_name             = var.bastion_key_name

  tags = {
    "Patch Group" = local.bastion_patch_group_name
    Name          = "${var.vpc_name} Bastion Host ${count.index}"
  }

  vpc_security_group_ids = [aws_security_group.utility_hosts.id]

  user_data = base64encode(templatefile("${path.module}/bastion.tftpl", {}))
}


locals {
  enable_single_bastion_eip = var.bastion_count == 1 && var.bastion_route53 != null
}

resource "aws_eip" "single_bastion_eip" {
  count                     = local.enable_single_bastion_eip ? 1 : 0
  vpc                       = true
  instance                  = aws_instance.bastion_hosts[0].id
  public_ipv4_pool          = "amazon"
  depends_on                = [aws_internet_gateway.igw]
}

data "aws_route53_zone" "root_zone" {
  count = local.enable_single_bastion_eip ? 1 : 0
  name  = var.bastion_route53.zone.name
}

resource "aws_route53_record" "eip_a_record" {
  count   = local.enable_single_bastion_eip ? 1 : 0
  type    = "A"
  name    = var.bastion_route53.record.name
  zone_id = data.aws_route53_zone.root_zone[0].zone_id
  records = [aws_eip.single_bastion_eip[0].public_ip]
  ttl     = 300
}