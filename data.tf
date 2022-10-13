# KMS Key Policy
data "aws_iam_policy_document" "kms_policy" {
  count = length(var.principals) >= 0 && var.account_id != null ? 1 : 0

  source_policy_documents = [
    templatefile("${path.module}/assets/policy/kms/default.json.tpl", { account_id = var.account_id, principals = var.principals })
  ]
  override_policy_documents = var.custom_kms_policies
}


data "aws_iam_policy_document" "secret_policy" {
  count                     = var.account_id != null && var.account_id != "" ? 1 : 0
  source_json               = templatefile("${path.module}/assets/policy/secret/default.json.tpl", { account_id = var.account_id })
  override_policy_documents = var.custom_secret_policies
}