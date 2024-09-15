resource "aws_security_group" "bastion" {
  name        = "private"
  description = "Security Group for private"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "bastion"
  }
}

locals {
  ssh_ips = [ aws_instance.reverseproxy.private_ip, aws_instance.docker.private_ip]
}

resource "aws_vpc_security_group_ingress_rule" "bastion_allow_ssh" {

  for_each = toset(local.ssh_ips)

  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "${each.key}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "Allow SSH connection"
  tags              = var.tags
}


resource "aws_vpc_security_group_egress_rule" "bastion_allow_ssh" {

  for_each = toset(local.ssh_ips)

  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "${each.key}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "Allow SSH connection"
  tags              = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "bastion_allow_ssh_dev" {

  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "${var.public_ip}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "Allow SSH connection"
  tags              = var.tags
}


resource "aws_vpc_security_group_egress_rule" "bastion_allow_ssh_dev" {

  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "${var.public_ip}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "Allow SSH connection"
  tags              = var.tags
}

# ??? WARNING: need a "gate" to update apt , iptables could be dynamically set ? it is done as a 'quick win'

resource "aws_vpc_security_group_ingress_rule" "fix_allow_http" {

  security_group_id = aws_security_group.reverseproxy.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  tags              = var.tags
}


resource "aws_vpc_security_group_egress_rule" "fix_allow_http" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  tags              = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "fix_allow_https" {

  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  tags              = var.tags
}


resource "aws_vpc_security_group_egress_rule" "fix_allow_https" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  tags              = var.tags
}