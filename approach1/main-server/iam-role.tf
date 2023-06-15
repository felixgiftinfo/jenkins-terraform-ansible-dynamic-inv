resource "aws_iam_role" "jenkin_ec2_role" {
  name               = "jenkins-ec2-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
}
EOF
  tags = {
    Name = "Jenkin Ec2 Role"
  }
}


resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "Jenkins_Profile"
  role = aws_iam_role.jenkin_ec2_role.name
}
