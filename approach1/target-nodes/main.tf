
#https://github.com/MithunTechnologiesDevOps/Terraform_Scripts



locals {
  ami               = data.aws_ami.primary.id
  security_group_id = data.aws_security_group.selected.id
}


resource "aws_instance" "ansible_target_node_server" {
  tags = {
    "Name" = "ansible-node"
  }
  ami                    = local.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ansible_node_sg.id]
  count                  = 2
}

output "node_1_url" {
  value = join("", ["http://", aws_instance.ansible_target_node_server[0].public_ip])
}

output "node_2_url" {
  value = "http://${aws_instance.ansible_target_node_server[1].public_ip}"
}

# output "node_3_url" {
#   value = "http://${aws_instance.ansible_target_node_server[2].public_ip}"
# }

# output "node_4_url" {
#   value = "http://${aws_instance.ansible_target_node_server[3].public_ip}"
# }
