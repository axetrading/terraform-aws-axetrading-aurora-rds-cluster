# Default KMS Key for Secret encryption
resource "aws_kms_key" "this" {
  count = var.present && var.kms_key_present ? 1 : 0

  description              = "KMS key used for the encryption of Aurora"
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec
  policy                   = try(data.aws_iam_policy_document.kms_policy[0].json, var.kms_key_policy)
  deletion_window_in_days  = var.deletion_window_in_days
  is_enabled               = var.is_enabled
  enable_key_rotation      = var.enable_key_rotation

  tags = {
    Name = var.kms_key_name
  }
}

# AWS KMS Key Alias
resource "aws_kms_alias" "this" {
  count = var.present && var.kms_key_present ? 1 : 0

  name          = "alias/secret/${var.cluster_identifier}"
  target_key_id = try(element(aws_kms_key.this.*.key_id, 0), "")
}

