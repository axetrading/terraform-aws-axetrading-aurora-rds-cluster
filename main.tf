resource "random_password" "password" {
  count = var.present ? 1 : 0

  length           = 16
  special          = true
  override_special = "_%"
}

resource "aws_rds_cluster" "this" {
  count = var.present ? 1 : 0

  cluster_identifier   = var.cluster_identifier
  db_subnet_group_name = aws_db_subnet_group.this.0.name

  availability_zones            = var.availability_zones
  master_username               = var.master_username
  master_password               = var.snapshot_identifier != null && var.manage_master_user_password != true ? null : random_password.password.0.result
  manage_master_user_password   = var.master_password == null && var.manage_master_user_password ? var.manage_master_user_password : null
  master_user_secret_kms_key_id = var.manage_master_user_password && var.kms_key_present ? aws_kms_key.this[0].arn : try(var.master_user_secret_kms_key_id, null)

  apply_immediately      = var.apply_immediately
  backtrack_window       = var.backtrack_window
  copy_tags_to_snapshot  = var.copy_tags_to_snapshot
  deletion_protection    = var.deletion_protection
  enable_http_endpoint   = var.enable_http_endpoint
  engine_mode            = !var.is_serverless ? var.engine_mode : "serverless"
  engine_version         = var.engine_version
  engine                 = var.engine
  iam_roles              = var.iam_roles
  kms_key_id             = var.kms_key_present ? aws_kms_key.this[0].arn : var.kms_key_id
  port                   = var.port
  storage_encrypted      = var.storage_encrypted
  vpc_security_group_ids = concat([aws_security_group.this[0].id], var.vpc_security_group_ids)

  snapshot_identifier                 = var.snapshot_identifier
  final_snapshot_identifier           = format("%s-%s", var.cluster_identifier, var.final_snapshot_identifier_suffix)
  skip_final_snapshot                 = var.skip_final_snapshot
  backup_retention_period             = var.backup_retention_period
  preferred_backup_window             = var.preferred_backup_window
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  tags = var.tags
}

resource "aws_db_subnet_group" "this" {
  count = var.present ? 1 : 0

  name       = var.subnet_group_name != null && var.subnet_group_name != "" ? var.subnet_group_name : format("%s-%s", var.cluster_identifier, "subnet-group")
  subnet_ids = var.subnet_ids
}

resource "aws_rds_cluster_instance" "this" {
  for_each = var.present && !var.is_serverless ? { for i, r in var.db_cluster_instances : r.name => r if try(r.present, "true") == "true" } : {}

  identifier                   = each.value.name
  identifier_prefix            = try(each.value.prefix, null)
  cluster_identifier           = try(aws_rds_cluster.this[0].id, "")
  engine                       = var.engine
  engine_version               = var.engine_version
  instance_class               = try(each.value.class, "db.r4.large")
  publicly_accessible          = try(each.value.publicly_accessible, "false")
  db_subnet_group_name         = aws_db_subnet_group.this.0.name
  db_parameter_group_name      = var.create_parameter_group ? try(aws_db_parameter_group.this[0].name, null) : var.parameter_group_name
  apply_immediately            = var.apply_immediately
  monitoring_role_arn          = try(each.value.monitoring_role_arn, null)
  monitoring_interval          = try(each.value.monitoring_interval, 0)
  promotion_tier               = try(each.value.promotion_tier, null)
  availability_zone            = try(each.value.availability_zone, var.availability_zones[0], null)
  preferred_maintenance_window = try(each.value.preferred_maintenance_window, null)
  auto_minor_version_upgrade   = try(each.value.auto_minor_version_upgrade, false)
  copy_tags_to_snapshot        = var.copy_tags_to_snapshot

  tags = var.tags

  timeouts {
    create = try(each.value.timeouts.create, null)
    update = try(each.value.timeouts.update, null)
    delete = try(each.value.timeouts.delete, null)
  }
}

resource "aws_db_parameter_group" "this" {
  count = var.present && var.create_parameter_group ? 1 : 0

  name        = var.parameter_group_name
  family      = var.parameter_group_family
  description = var.parameter_group_description

  dynamic "parameter" {
    for_each = var.parameter_group_parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }
}