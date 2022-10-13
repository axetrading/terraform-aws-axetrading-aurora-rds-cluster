resource "aws_secretsmanager_secret" "this" {
  count = var.present && var.create_secret ? 1 : 0

  name                    = var.cluster_identifier
  description             = "Secret to contain password for RDS"
  recovery_window_in_days = 0
  kms_key_id              = var.secrets_manager_kms_key_id
  policy                  = var.secret_policy
}

resource "aws_secretsmanager_secret_version" "this" {
  count = var.present && var.create_secret ? 1 : 0

  secret_id = aws_secretsmanager_secret.this.0.id
  secret_string = jsonencode({
    "clusteridentifier" = var.cluster_identifier
    "db_name"           = try(aws_rds_cluster.this.0.database_name, "")
    "engine"            = try(aws_rds_cluster.this.0.engine, "")
    "hosted_zone_id"    = try(aws_rds_cluster.this.0.hosted_zone_id, "")
    "port"              = try(aws_rds_cluster.this.0.port, "")
    "id"                = try(aws_rds_cluster.this.0.id, "")
    "master_username"   = try(aws_rds_cluster.this.0.master_username, "")
    "master_password"   = random_password.password.0.result
    "endpoint"          = try(aws_rds_cluster.this.0.endpoint, "")
    "reader_endpoint"   = try(aws_rds_cluster.this.0.reader_endpoint, "")
    "db_encrypted"      = try(aws_rds_cluster.this.0.storage_encrypted, "")
  })
}