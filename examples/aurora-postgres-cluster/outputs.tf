output "rds_cluster_arn" {
  value       = try(module.terratest_rds_cluster.rds_cluster_arn, "")
  description = "Aurora RDS Cluster ARN"
}

output "rds_cluster_id" {
  value       = try(module.terratest_rds_cluster.rds_cluster_id, "")
  description = "Aurora RDS Cluster ID"
}

output "rds_cluster_security_group_id" {
  value       = try(module.terratest_rds_cluster.rds_cluster_security_group_id, "")
  description = "Aurora RDS Cluster Security Group"
}

output "rds_cluster_secret_id" {
  value       = try(module.terratest_rds_cluster.rds_cluster_secret_id, "")
  description = "Aurora RDS Cluster Secret ID"
}

output "rds_cluster_identifier" {
  value       = try(module.terratest_rds_cluster.rds_cluster_identifier, "")
  description = "Aurora RDS Cluster ID"
}

output "rds_cluster_endpoint" {
  value       = try(module.terratest_rds_cluster.rds_cluster_endpoint, "")
  description = "The DNS address of the RDS instance"
}

output "rds_cluster_reader_endpoint" {
  value       = try(module.terratest_rds_cluster.rds_cluster_reader_endpoint, "")
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
}

output "private_subnet_cidrs" {
  value       = try(module.subnets.private_subnet_cidrs, [])
  description = "Private subnet CIDR blocks"
}

output "vpc_cidr" {
  value       = try(module.vpc.vpc_cidr_block, "")
  description = "VPC CIDR"
}

output "vpc_id" {
  value       = try(module.vpc.vpc_id, "")
  description = "VPC ID"
}
