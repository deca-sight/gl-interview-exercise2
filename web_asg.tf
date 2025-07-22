locals {
  user_data_web = base64encode(templatefile("${path.module}/templates/user_data_web.tpl", {}))
}

module "app_asg" {
  source  = "cloudposse/ec2-autoscale-group/aws"
  version = "0.41.1"

  # Naming
  namespace   = var.asg_namespace
  stage       = var.asg_stage
  environment = var.asg_environment
  name        = var.asg_name

  # Networking & Instances
  image_id                    = data.aws_ami.redhat.id
  instance_type               = var.asg_instance_type
  subnet_ids                  = module.network.private_subnets
  security_group_ids          = [module.sg_web_asg.id]  # ajustar SG
  associate_public_ip_address = false
  health_check_type           = var.asg_health_check_type
  health_check_grace_period     = var.asg_health_check_grace_period
  wait_for_capacity_timeout   = var.asg_wait_for_capacity_timeout
  target_group_arns = [module.alb.target_groups["web"].arn]
  iam_instance_profile_name = aws_iam_instance_profile.asg_profile.name
  key_name                    = var.key_name


  # Auto Scaling
  min_size = var.asg_min_size
  max_size = var.asg_max_size

  # User Data
  user_data_base64 = local.user_data_web

  # Root volume
  block_device_mappings = [
    {
      device_name  = "/dev/xvda"
      no_device    = "false"
      virtual_name = "root"
      ebs = {
        encrypted             = true
        volume_size           = var.asg_root_volume_size
        delete_on_termination = true
        iops                  = null
        kms_key_id            = data.aws_kms_key.ebs.arn  
        snapshot_id           = null
        volume_type           = var.asg_root_volume_type
      }
    }
  ]

  # Tags
  tags = merge(var.tags, {
    "Name"        = "app"
    "ManagedBy"   = "terraform"
    "Environment" = "prod"
  })

  # Optional: Scaling policies
  autoscaling_policies_enabled           = true
  cpu_utilization_high_threshold_percent = var.asg_cpu_high_threshold
  cpu_utilization_low_threshold_percent  = var.asg_cpu_low_threshold
}