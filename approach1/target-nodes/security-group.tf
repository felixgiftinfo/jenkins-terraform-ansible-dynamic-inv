
resource "aws_security_group" "ansible_node_sg" {
  name        = "ansible_node-sg"
  description = "Inbound: SSH, HTTP. Outbound: all."

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.cidr_block
    ipv6_cidr_blocks = var.ipv6_cidr_block
  }
  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = var.cidr_block
    security_groups = [local.security_group_id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.cidr_block
    ipv6_cidr_blocks = var.ipv6_cidr_block
  }
}
