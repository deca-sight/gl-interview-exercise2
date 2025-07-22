module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "9.17.0"

  name    = var.alb_name
  vpc_id  = module.network.vpc_id
  subnets = module.network.public_subnets
  security_groups = [module.alb-sg.id]
  enable_deletion_protection = var.alb_enable_deletion_protection


  listeners = {
    ex-https = {
      port            = var.alb_listener_port
      protocol        = var.alb_listener_protocol

      forward = {
        target_group_key = "web"
      }
    }
  }

  target_groups = {
    web = {
      name_prefix = var.alb_target_group_name_prefix
      protocol    = var.alb_target_group_protocol
      port        = var.alb_target_group_port
      target_type = "instance"
      create_attachment = false

      health_check = {
        path                = "/"
        protocol            = "HTTPS"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
      }
    }
  }

  tags = {
    Environment = "Development"
    Project     = "Example"
  }
}
