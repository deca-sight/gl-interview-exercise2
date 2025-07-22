module "images_read_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.59.0"

  name        = var.iam_policy_read_images_name
  path        = "/"
  description = "Policy allowing read access to the images S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowListBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::images-coalfire"
      },
      {
        Sid    = "AllowGetObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "arn:aws:s3:::images-coalfire/*"
      }
    ]
  })
}

module "logs_write_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = var.iam_policy_write_logs_name
  path        = "/"
  description = "Allows writing logs to the log bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "AllowPutLogsToBucket",
        Effect = "Allow",
        Action = [
          "s3:PutObject"
        ],
        Resource = "arn:aws:s3:::logs-coalfire/*"
      }
    ]
  })
}

module "instance_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.34.0"

  role_name               = var.iam_role_asg_name
  create_role             = true
  trusted_role_services   = ["ec2.amazonaws.com"]
  custom_role_policy_arns = [module.images_read_policy.arn, module.logs_write_policy.arn]

  role_requires_mfa = false


  tags = var.tags
}

resource "aws_iam_instance_profile" "asg_profile" {
  name = var.iam_instance_profile_asg_name
  role = module.instance_role.iam_role_name
}
