resource "aws_instance" "bastion" {

  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.main.key_name
  subnet_id                   = aws_subnet.public.id
  security_groups             = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  availability_zone           = "eu-west-3a"
  private_ip                  = "10.0.1.4" # aws subnet reserves 4 first ip address
  user_data                   = "name=bastion"

  root_block_device {
    volume_size = 10
  }
  tags = {
    Name = "bastion"
  }
  depends_on = [aws_security_group.bastion.id]
}


resource "aws_instance" "reverseproxy" {

  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.main.key_name
  subnet_id                   = aws_subnet.public.id
  security_groups             = [aws_security_group.reverseproxy.id]
  associate_public_ip_address = true
  availability_zone           = "eu-west-3a"
  private_ip                  = "10.0.1.5" # aws subnet reserves 4 first ip address
  user_data                   = "name=reverseproxy"

  root_block_device {
    volume_size = 10
  }
  tags = {
    Name = "reverseproxy_1"
  }
  depends_on = [aws_security_group.reverseproxy.id]
}

resource "aws_instance" "docker" {

  ami                         = var.ami_id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.main.key_name
  subnet_id                   = aws_subnet.private.id
  security_groups             = [aws_security_group.docker.id]
  associate_public_ip_address = false
  availability_zone           = "eu-west-3a"
  private_ip                  = "10.0.2.4" # aws subnet reserves 4 first ip address so starts at 4
  user_data                   = "name=docker"

  root_block_device {
    volume_size = 8
  }
  tags = {
    Name = "docker"
  }
  depends_on = [aws_security_group.docker.id]
}