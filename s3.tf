module "s3_images" {
  source = "github.com/Coalfire-CF/terraform-aws-s3?ref=v1.0.4"

  name = var.s3_images_bucket_name

  enable_lifecycle_configuration_rules = true
  force_destroy = var.s3_force_destroy

  lifecycle_configuration_rules = [
    {
      id      = "memes-to-glacier"
      enabled = true
      prefix  = "memes/"

      enable_glacier_transition        = true
      glacier_transition_days          = 90

      enable_current_object_expiration     = false
      enable_noncurrent_version_expiration = false

      noncurrent_version_expiration_days             = 365
      noncurrent_version_glacier_transition_days     = 90
      noncurrent_version_deeparchive_transition_days = null
      abort_incomplete_multipart_upload_days         = null
      standard_transition_days                       = null
      deeparchive_transition_days                    = null
      expiration_days                                = null
    }
  ]

  enable_kms                    = true
  enable_server_side_encryption = true
  kms_master_key_id             = data.aws_kms_key.s3.arn

  tags = var.tags
}


module "s3_logs" {
  source = "github.com/Coalfire-CF/terraform-aws-s3?ref=v1.0.4"

  name = var.s3_logs_bucket_name
  force_destroy = var.s3_force_destroy

  enable_lifecycle_configuration_rules = true
  lifecycle_configuration_rules = [
    {
      id      = "active-to-glacier"
      enabled = true
      prefix  = "active/"

      enable_glacier_transition        = true
      glacier_transition_days          = 90
      enable_current_object_expiration = false
      enable_noncurrent_version_expiration = false

      noncurrent_version_expiration_days             = 365
      noncurrent_version_glacier_transition_days     = 90
      noncurrent_version_deeparchive_transition_days = null
      abort_incomplete_multipart_upload_days         = null
      standard_transition_days                       = null
      deeparchive_transition_days                    = null
    },
    {
      id      = "inactive-delete"
      enabled = true
      prefix  = "inactive/"

      expiration_days                = 90
      enable_current_object_expiration = true
      enable_glacier_transition        = false
      enable_noncurrent_version_expiration = false

      glacier_transition_days                    = null
      noncurrent_version_expiration_days         = 365
      noncurrent_version_glacier_transition_days = 90
      noncurrent_version_deeparchive_transition_days = null
      abort_incomplete_multipart_upload_days     = null
      standard_transition_days                   = null
      deeparchive_transition_days                = null
    }
  ]

  enable_kms                    = true
  enable_server_side_encryption = true
  kms_master_key_id             = data.aws_kms_key.s3.arn

  tags = var.tags
}
