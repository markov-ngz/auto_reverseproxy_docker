resource "aws_security_group" "docker" {
  name        = "docker"
  description = "Unsecure security group for a docker instance"
  vpc_id      = aws_vpc.main.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "docker_allow_ssh_bastion" {

  security_group_id = aws_security_group.docker.id
  cidr_ipv4         = "${aws_instance.bastion.private_ip}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "Allow SSH connection from dev"
  tags              = var.tags
}


resource "aws_vpc_security_group_egress_rule" "docker_allow_ssh_bastion" {
  security_group_id = aws_security_group.docker.id

  cidr_ipv4   = "${aws_instance.bastion.private_ip}/32"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}



resource "aws_vpc_security_group_ingress_rule" "docker_allow_http" {

  security_group_id = aws_security_group.docker.id
  cidr_ipv4         = "10.0.1.0/24"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  tags              = var.tags
}


resource "aws_vpc_security_group_egress_rule" "docker_allow_http" {
  security_group_id = aws_security_group.docker.id
  cidr_ipv4        = "10.0.1.0/24"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  tags              = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "docker_allow_https" {

  security_group_id = aws_security_group.docker.id
  cidr_ipv4         = "10.0.1.0/24"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  tags              = var.tags
}


resource "aws_vpc_security_group_egress_rule" "docker_allow_https" {
  security_group_id = aws_security_group.docker.id
  cidr_ipv4         = "10.0.1.0/24"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  tags              = var.tags
}

