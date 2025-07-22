module "sg_web_asg" {
  source = "github.com/Coalfire-CF/terraform-aws-securitygroup?ref=v1.0.1"

  name   = var.sg_web_asg_name
  vpc_id = module.network.vpc_id
  tags   = merge(var.tags, {
    "Name" = "web-asg-sg"
  })

  ingress_rules = {
    "allow_https" = {
      ip_protocol = "tcp"
      from_port   = 443
      to_port     = 443
      referenced_security_group_id = module.alb-sg.id

    }
    "allow_http" = {
      ip_protocol = "tcp"
      from_port   = 80
      to_port     = 80
      referenced_security_group_id = module.alb-sg.id
    }
    "allow_ssh" = {
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
      referenced_security_group_id = module.bastion_host.sg_id

    }
  }

  egress_rules = {
    "allow_all_egress" = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all egress"
    }
  }
}

module "alb-sg" {
  source = "github.com/Coalfire-CF/terraform-aws-securitygroup?ref=v1.0.1"

  name   = var.sg_alb_name
  vpc_id = module.network.vpc_id
  tags   = merge(var.tags, {
    "Name" = "alb-sg"
  })

  ingress_rules = {
    "allow_https" = {
      ip_protocol = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_ipv4   = "0.0.0.0/0"
    }
    "allow_http" = {
      ip_protocol = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  egress_rules = {
    "allow_all_egress" = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all egress"
    }
  }
}
