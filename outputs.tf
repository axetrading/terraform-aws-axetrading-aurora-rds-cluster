output "rds_cluster_arn" {
  value       = try(aws_rds_cluster.this.0.arn, "")
  description = "Aurora RDS Cluster ARN"
}

output "rds_cluster_id" {
  value       = try(aws_rds_cluster.this.0.id, "")
  description = "Aurora RDS Cluster ID"
}

output "rds_cluster_security_group_id" {
  value       = try(aws_security_group.this.0.id, "")
  description = "Aurora RDS Cluster Security Group"
}

output "rds_cluster_secret_id" {
  value       = try(aws_secretsmanager_secret.this.0.id, "")
  description = "Aurora RDS Cluster Secret ID"
}

output "rds_cluster_identifier" {
  value       = try(aws_rds_cluster.this.0.cluster_identifier, "")
  description = "Aurora RDS Cluster ID"
}

output "rds_cluster_endpoint" {
  value       = try(aws_rds_cluster.this.0.endpoint, "")
  description = "The DNS address of the RDS instance"
}

output "rds_cluster_reader_endpoint" {
  value       = try(aws_rds_cluster.this.0.reader_endpoint, "")
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
}

output "rds_hosted_zone_id" {
  value       = try(aws_rds_cluster.this.0.hosted_zone_id, "")
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
}

output "rds_cluster_managed_master_password_secret" {
  value       = try(aws_rds_cluster.this.0.master_user_secret, "")
  description = "The name of the secret containing the master user password"
}