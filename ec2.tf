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

data "template_file" "bastion_template" {
  template = <<EOF
#!/bin/bash
sudo yum -y update
EOF
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
    Name          = "${var.vpc_name} Bastion Host ${var.bastion_count}"
  }

  vpc_security_group_ids = [aws_security_group.utility_hosts.id]

  user_data = base64encode(data.template_file.bastion_template.rendered)
}
