module "terratest_rds_cluster" {
  source              = "../../"
  cluster_identifier  = "terratest"
  availability_zones  = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  name                = "terratest"
  master_username     = "terratest"
  storage_encrypted   = true
  apply_immediately   = true
  deletion_protection = false
  engine_mode         = "provisioned"
  engine              = "aurora-postgresql"
  engine_version      = "14.3"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.subnets.private_subnet_ids
  db_cluster_instances = {
    "eu-west-2a" = {
      name                       = "terratest"
      class                      = "db.t3.medium"
      availability_zone          = "eu-west-2a"
      auto_minor_version_upgrade = true
      preferred_backup_window    = "wed:03:00-wed:04:00"
    }
  }
  security_group_rules = {
    ingress_db_5432 = {
      description = "Node groups to cluster API"
      protocol    = "tcp"
      from_port   = 5432
      to_port     = 5432
      type        = "ingress"
      cidr_blocks = [module.vpc.vpc_cidr_block]

    }
  }

}