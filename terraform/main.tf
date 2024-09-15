terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
    local = {
      source = "hashicorp/local"
    }

  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-3"
}

resource "aws_key_pair" "main" {
  key_name   = var.key_name
  public_key = file("${var.ec2_public_key}")
  tags = {
    Name = var.key_name
  }
}


resource "local_file" "ssh_config" {
  content  = <<EOT
Host *
ForwardAgent yes
Host bastion
    Hostname ${aws_instance.bastion.public_ip}
    User ${var.ec2_default_user}
    IdentityFile ${var.ec2_private_key}
    Port 22
Host reverseproxy_sudo
    Hostname ${aws_instance.reverseproxy.private_ip}
    User ${var.ec2_default_user}
    IdentityFile ${var.ec2_private_key}
    Port 22
    ProxyJump bastion

Host reverseproxy
    Hostname ${aws_instance.reverseproxy.private_ip}
    User ${var.user_name}
    IdentityFile ${var.user_private_key}
    Port 22
    ProxyJump bastion

Host docker_sudo
    Hostname ${aws_instance.docker.private_ip}
    User ${var.ec2_default_user}
    IdentityFile ${var.ec2_private_key}
    Port 22
    ProxyJump bastion
Host docker
    Hostname ${aws_instance.docker.private_ip}
    User ${var.user_name}
    IdentityFile ${var.user_private_key}
    Port 22
    ProxyJump bastion
EOT 
  filename = "${var.ansible_relative_path}/config"
}