resource "aws_iam_policy" "jenkins_ec2_policies" {
  name   = "JenkinsEc2_Policies"
  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"ec2:*",
				"route53:*",
				"autoscaling:*",
				"elasticloadbalancing:*",
				"cloudwatch:*",
				"s3:*"
			],
			"Resource": "*"
		}
	]
}
EOF
  tags = {
    "Name" = "Jenkins EC2 Policies"
  }
}

resource "aws_iam_role_policy_attachment" "s3_pol_attachment" {
  role       = aws_iam_role.jenkin_ec2_role.name
  policy_arn = aws_iam_policy.jenkins_ec2_policies.arn
}
