
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow Jenkins Traffic"

  ingress {
    description = "Allow from Personal CIDR block"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.cidr_block
  }

  ingress {
    description = "Allow SSH from Personal CIDR block"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_block
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.cidr_block
    ipv6_cidr_blocks = var.ipv6_cidr_block
  }

  tags = {
    Name = "Jenkins SG"
  }
}


resource "aws_security_group" "ansible_engine_sg" {
  name        = "ansible_engine_sg"
  description = "Inbound: SSH, HTTP. Outbound: all."

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.cidr_block
    ipv6_cidr_blocks = var.ipv6_cidr_block
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.cidr_block
    ipv6_cidr_blocks = var.ipv6_cidr_block
  }
}

