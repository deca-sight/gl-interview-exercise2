data "aws_ami" "redhat" {
  most_recent = true
  owners      = [var.ami_redhat_owner] # Official owner of RHEL in AWS Marketplace

  filter {
    name   = "name"
    values = [var.ami_redhat_name_filter]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_kms_key" "ebs" {
  key_id = "alias/aws/ebs"
}
data "aws_kms_key" "s3" {
  key_id = "alias/aws/s3"
}
