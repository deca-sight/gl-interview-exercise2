# -----------------------------------------
# Basic Configuration
# -----------------------------------------
variable "region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "cidr_for_remote_access" {
  description = "CIDR block allowed to access the bastion host (e.g., your IP or a range)"
  type        = string
}

variable "tags" {
  description = "Global tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# -----------------------------------------
# Bastion Configuration
# -----------------------------------------
variable "bastion_name" {
  description = "Name of the Bastion host instance"
  type        = string
}

variable "bastion_instance_type" {
  description = "EC2 instance type for the Bastion host"
  type        = string
}

variable "bastion_instance_count" {
  description = "Number of Bastion instances to launch"
  type        = number
}

variable "bastion_root_volume_size" {
  description = "Root volume size (in GB) for the Bastion instance"
  type        = number
}

variable "bastion_associate_eip" {
  description = "Whether to associate an Elastic IP to the Bastion host"
  type        = bool
}

# -----------------------------------------
# Auto Scaling Group (ASG) Configuration
# -----------------------------------------
variable "asg_namespace" {
  description = "Logical namespace prefix for ASG resources"
  type        = string
}

variable "asg_stage" {
  description = "Logical stage label (e.g., asg, app)"
  type        = string
}

variable "asg_environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "asg_name" {
  description = "Base name for the Auto Scaling Group"
  type        = string
}

variable "asg_instance_type" {
  description = "EC2 instance type for ASG instances"
  type        = string
}

variable "asg_health_check_type" {
  description = "Type of health check used (EC2 or ELB)"
  type        = string
}

variable "asg_health_check_grace_period" {
  description = "The amount of time (in seconds) that Auto Scaling waits before checking the health status of a newly launched instance."
  type        = number
}

variable "asg_wait_for_capacity_timeout" {
  description = "The maximum duration Terraform should wait for the Auto Scaling Group to reach the desired capacity. Example: '5m' or '0' to disable waiting."
  type        = string
  default     = "5m"
}

variable "asg_min_size" {
  description = "Minimum number of instances in the ASG"
  type        = number
}

variable "asg_max_size" {
  description = "Maximum number of instances in the ASG"
  type        = number
}

variable "asg_cpu_high_threshold" {
  description = "CPU utilization threshold (%) to scale out"
  type        = string
}

variable "asg_cpu_low_threshold" {
  description = "CPU utilization threshold (%) to scale in"
  type        = string
}

variable "asg_root_volume_size" {
  description = "Size of the root EBS volume for ASG instances (in GB)"
  type        = number
}

variable "asg_root_volume_type" {
  description = "Type of root EBS volume (e.g., gp2, gp3)"
  type        = string
}

# -----------------------------------------
# Application Load Balancer (ALB) Configuration
# -----------------------------------------
variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "alb_enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
}

variable "alb_listener_port" {
  description = "Port number for the ALB listener (e.g., 80)"
  type        = number
}

variable "alb_listener_protocol" {
  description = "Protocol for the ALB listener (HTTP or HTTPS)"
  type        = string
}

variable "alb_target_group_name_prefix" {
  description = "Prefix for the ALB target group name"
  type        = string
}

variable "alb_target_group_protocol" {
  description = "Protocol used for the ALB target group (HTTP or HTTPS)"
  type        = string
}

variable "alb_target_group_port" {
  description = "Port on which targets receive traffic from the ALB"
  type        = number
}

# -----------------------------------------
# S3 Buckets Configuration
# -----------------------------------------
variable "s3_images_bucket_name" {
  description = "Name of the S3 bucket used for storing images"
  type        = string
}

variable "s3_logs_bucket_name" {
  description = "Name of the S3 bucket used for storing logs"
  type        = string
}

variable "s3_force_destroy" {
  description = "Whether to force destroy the S3 bucket even if it contains objects"
  type        = bool
}

# -----------------------------------------
# Terraform Backend Configuration
# -----------------------------------------
variable "tfstate_s3_bucket_name" {
  description = "Name of the S3 bucket for Terraform remote state"
  type        = string
}

variable "tflock_dynamodb_table_name" {
  description = "Name of the DynamoDB table for Terraform state locking"
  type        = string
}

# -----------------------------------------
# IAM Configuration
# -----------------------------------------
variable "iam_policy_read_images_name" {
  description = "IAM policy name for reading from the image bucket"
  type        = string
}

variable "iam_policy_write_logs_name" {
  description = "IAM policy name for writing to the logs bucket"
  type        = string
}

variable "iam_role_asg_name" {
  description = "IAM role name to be assumed by ASG EC2 instances"
  type        = string
}

variable "iam_instance_profile_asg_name" {
  description = "Name of the IAM instance profile for the ASG instances"
  type        = string
}

# -----------------------------------------
# Security Groups Configuration
# -----------------------------------------
variable "sg_web_asg_name" {
  description = "Name of the Security Group assigned to ASG instances"
  type        = string
}

variable "sg_alb_name" {
  description = "Name of the Security Group assigned to the ALB"
  type        = string
}

# -----------------------------------------
# Data Source Filters
# -----------------------------------------
variable "ami_redhat_owner" {
  description = "AWS account ID of the Red Hat AMI owner"
  type        = string
}

variable "ami_redhat_name_filter" {
  description = "Filter used to select the latest Red Hat AMI"
  type        = string
}
