variable "tags" {
  type        = map(string)
  description = "resource's tag"
}

variable "dns_name" {
  type = string
  sensitive = true
}

variable "public_ip" {
  type      = string
  sensitive = true
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type        = string
  description = ""
}

variable "key_name" {
  type = string
}

variable "ec2_private_key" {
  type        = string
  sensitive   = true
  description = "private key path relative to the ansible  execution"
}

variable "ec2_public_key" {
  type        = string
  sensitive   = true
  description = "public key path"
}

variable "ec2_default_user" {
  type    = string
  default = "ubuntu"
}

variable "user_private_key" {
  type        = string
  sensitive   = true
  description = "private key path relative to the ansible execution"
}

variable "user_name" {
  type = string
}


variable "ansible_relative_path" {
  type      = string
  sensitive = false
  default   = "../ansible"
}
