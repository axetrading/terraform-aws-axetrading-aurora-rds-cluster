data "aws_caller_identity" "current" {}
# KMS Key Policy

locals {
  account_id = data.aws_caller_identity.current.account_id
  principals = flatten(concat([data.aws_caller_identity.current.arn], var.principals))
}

data "aws_iam_policy_document" "kms_policy" {
  count = var.kms_key_present && length(local.principals) >= 1 && local.account_id != null ? 1 : 0

  source_policy_documents = [
    templatefile("${path.module}/assets/policy/kms/default.json.tpl", { account_id = local.account_id, principals = local.principals })
  ]
  override_policy_documents = var.custom_kms_policies
}


data "aws_iam_policy_document" "secret_policy" {
  count                     = var.create_secret && local.account_id != null ? 1 : 0
  source_json               = templatefile("${path.module}/assets/policy/secret/default.json.tpl", { account_id = local.account_id })
  override_policy_documents = var.custom_secret_policies
}