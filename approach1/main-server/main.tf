locals {
  ami               = data.aws_ami.primary.id
  user              = data.aws_ami.primary.root_device_name
  jenkins_user_data = <<EOF
#!/bin/bash


# Install Jenkins
sudo yum update –y
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins

# Install Ansible
sudo yum install python3 -y
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
terraform --version
sudo python -m ensurepip --upgrade
sudo pip install boto3
sudo amazon-linux-extras install ansible2 -y
sudo yum install git -y
EOF

  ansible_user_data = <<EOF
#!/bin/bash
sudo useradd zinc
echo "zinc ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/zinc
sudo su zinc
sudo yum update
sudo yum install python3 -y
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
terraform --version
sudo python -m ensurepip --upgrade
sudo pip install boto3
sudo amazon-linux-extras install ansible2 -y
sudo yum install git -y
EOF
}
#https://github.com/MithunTechnologiesDevOps/Terraform_Scripts

# pip install --upgrade pip

# sudo python -m ensurepip --upgrade
# sudo pip install boto3

# python3 -m venv venv
# source ./venv/bin/activate
# sudo pip install --upgrade pip boto3



#  1. create ~/.aws/config 
#  2. enter [default] /r/n region=us-east-1

#  Steps to follow
#  1. ssh to the ansible server(ec2 instance) and run this command sudo su zinc and cd ..
#  8. copy the DynamicInventory.py to the server and run this command 
#  9. chmod +x DynamicInventory.py (it makes it executable)
#  3. test if the python script can reach the target nodes servers IP with this this command 
#  4. ./DynamicInventory.py
#  8. copy the engine-config to the server
#  4. Create a key file call ansible-key.pem and copy its value from local.
#  5. chmod 400 ansible-key.pem
#  6. ansible ansible-nodes -i DynamicInventory.py -m ping --ssh-common-args='-o StrictHostKeyChecking=no' -u ec2-user --private-key=~/ansible-key.pem
#  7. ansible-playbook -i DynamicInventory.py engine-config.yml -u ec2-user --private-key=~/ansible-key.pem 

# ansible all -i DynamicInventory.py -m ping --ssh-common-args='-o StrictHostKeyChecking=no' -u ec2-user --private-key=~/ansible-key.pem
# ansible engine-config -i DynamicInventory.py -m ping --ssh-common-args='-o StrictHostKeyChecking=no' -u ec2-user --private-key=~/ansible-key.pem

# python3 -m venv venv
# source ./venv/bin/activate
# pip install --upgrade pip boto3


# sudo python -m ensurepip --upgrade 
# pip3 install boto3 --user
#  export AWS_DEFAULT_REGION=us-east-1
#  REDHAT AMI FREE TIER  ami-026ebd4cfe2c043b2
#  UBUNTU AMI FREE TIER  ami-053b0d53c279acc90
# 


# sudo amazon-linux-extras install ansible2 -y
# sudo yum install python3-pip -y
# sudo alternatives --set python /usr/bin/python3
# alias python='/usr/bin/python3.4'
# sudo yum -y install python3-boto -y
# pip3 install ansible --user
# pip3 install boto3 --user

# Upgrade pip
# sudo python -m ensurepip --upgrade     OR  sudo python -m pip install --upgrade pip

# sudo yum -y install python3-boto3
# sudo pip3 install boto3 --user

# sudo yum install -y nginx
# sudo install python3 -y

# locals {
#   ansible_user_data = <<EOF
#   #!/bin/bash
#   sudo su
#   yum update -y
#   amazon-linux-extras install ansible2 -y
#   EOF
# }


# https://api.github.com/meta

resource "aws_instance" "jenkins_server" {
  ami                  = local.ami
  instance_type        = var.instance_type
  key_name             = var.key_name
  security_groups      = [aws_security_group.jenkins_sg.name]
  iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name
  user_data            = local.jenkins_user_data
  tags = {
    Name = "Jenkins"
  }
}


output "jenkins_url" {
  value = join("", ["http://", aws_instance.jenkins_server.public_ip, ":8080"])
}
