variable "cidr_block" {
  default = ["0.0.0.0/0"]
}
variable "ipv6_cidr_block" {
  default = ["::/0"]
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "key_name" {
  type    = string
  default = "ansible-key"
}

data "aws_security_group" "selected" {
  name = "jenkins_sg"
}

data "aws_ami" "primary" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
