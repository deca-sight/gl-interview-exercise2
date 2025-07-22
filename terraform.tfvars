# -----------------------------------------
# General Configuration
# -----------------------------------------
key_name = "cloud-engineer-key"
cidr_for_remote_access = "0.0.0.0/0"
tags = {
  Environment = "prod"
  Project     = "gl-interview"
}

# -----------------------------------------
# Bastion Configuration (bastion.tf)
# -----------------------------------------
bastion_name          = "bastion"
bastion_instance_type = "t3.micro"
bastion_instance_count = 1
bastion_root_volume_size = 20
bastion_associate_eip = true

# -----------------------------------------
# Auto Scaling Group Configuration (web_asg.tf)
# -----------------------------------------
asg_namespace         = "gl"
asg_stage             = "asg"
asg_environment       = "prod"
asg_name              = "app"
asg_instance_type     = "t2.micro"
asg_health_check_type = "ELB"
asg_health_check_grace_period = 200
asg_wait_for_capacity_timeout = "5m"
asg_min_size          = 2
asg_max_size          = 6
asg_cpu_high_threshold = "70"
asg_cpu_low_threshold  = "20"
asg_root_volume_size   = 20
asg_root_volume_type   = "gp2"

# -----------------------------------------
# ALB Configuration (alb_web.tf)
# -----------------------------------------
alb_name = "alb"
alb_enable_deletion_protection = false
alb_listener_port = 80
alb_listener_protocol = "HTTP"
alb_target_group_name_prefix = "web"
alb_target_group_protocol = "HTTPS"
alb_target_group_port = 443

# -----------------------------------------
# S3 Buckets Configuration (s3.tf)
# -----------------------------------------
s3_images_bucket_name = "images-coalfire"
s3_logs_bucket_name   = "logs-coalfire"
s3_force_destroy      = true

# -----------------------------------------
# Backend Configuration (backend.tf)
# -----------------------------------------
# If backend is enabled, these values should be passed as variables.
# backend_s3_bucket         = "infra-org-tfstate"
# backend_s3_key            = "org/terraform.tfstate"
# backend_dynamodb_table    = "infra-org-tflock"
tfstate_s3_bucket_name = "gl-interview-exercise2-state"
tflock_dynamodb_table_name = "gl-interview2-tflock"

# -----------------------------------------
# IAM Configuration (iam.tf)
# -----------------------------------------
iam_policy_read_images_name = "read-images-bucket"
iam_policy_write_logs_name = "write-logs"
iam_role_asg_name = "asg-ec2-read-images"
iam_instance_profile_asg_name = "asg-ec2-instance-profile"

# -----------------------------------------
# Security Groups Configuration (sg.tf)
# -----------------------------------------
sg_web_asg_name = "web-asg-sg"
sg_alb_name     = "alb-sg"

# -----------------------------------------
# Data Source Filters (data.tf)
# -----------------------------------------
ami_redhat_owner = "309956199498"
ami_redhat_name_filter = "RHEL-8*_HVM-*-x86_64-*"