module "bastion_host" {
  source = "github.com/Coalfire-CF/terraform-aws-ec2?ref=v2.0.12"

  name               = var.bastion_name
  ami                = data.aws_ami.redhat.id
  ec2_instance_type  = var.bastion_instance_type
  instance_count     = var.bastion_instance_count
  subnet_ids         = [module.network.public_subnets[0]]
  vpc_id             = module.network.vpc_id
  ec2_key_pair       = var.key_name
  ebs_kms_key_arn = data.aws_kms_key.ebs.arn

  root_volume_size   = var.bastion_root_volume_size
  associate_eip      = var.bastion_associate_eip
  associate_public_ip = var.bastion_associate_eip
  iam_policies      = [module.logs_write_policy.arn]

  user_data = templatefile("${path.module}/templates/user_data_bastion.tpl", {})


  ingress_rules = {
    ssh = {
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_ipv4   = var.cidr_for_remote_access
      description = "SSH access"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all outbound traffic"
    }
  }

  global_tags = merge(var.tags, {
    Name = "bastion"
  })
}
