variable "present" {
  description = "Switch to determine whether resources should be provisioned or destroyed. Defaults to `true`"
  type        = bool
  default     = true
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-2"
}

variable "cluster_identifier" {
  description = "The cluster identifier. If omitted, Terraform will assign a random, unique identifier."
  default     = null
  type        = string
}

variable "availability_zones" {
  type        = set(string)
  default     = []
  description = "List of EC2 Availability Zones for the DB cluster storage where DB cluster instances can be created. RDS automatically assigns 3 AZs if less than 3 AZs are configured, which will show as a difference requiring resource recreation next Terraform apply"
}

variable "name" {
  type        = string
  description = "Name for an automatically created database on cluster creation"
  default     = ""
}

variable "master_username" {
  type        = string
  default     = "admin"
  description = "Required unless a snapshot_identifier or replication_source_identifier is provided or unless a global_cluster_identifier is provided when the cluster is the secondary cluster of a global database) Username for the master DB user"
}

variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. Default is false"
  default     = false
}

variable "backtrack_window" {
  type        = number
  description = "The target backtrack window, in seconds. Only available for aurora and aurora-mysql engines currently. To disable backtracking, set this value to 0. Defaults to 0. Must be between 0 and 259200 (72 hours)"
  default     = 0
}

variable "copy_tags_to_snapshot" {
  type        = bool
  description = "Copy all Cluster tags to snapshots. Default is false"
  default     = false
}

variable "deletion_protection" {
  type        = bool
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true"
  default     = true
}

variable "enable_http_endpoint" {
  type        = bool
  description = "Enable HTTP endpoint (data API). Only valid when engine_mode is set to serverless"
  default     = false
}

variable "engine_mode" {
  type        = string
  default     = "provisioned"
  description = "The database engine mode. Valid values: `parallelquery`, `provisioned`, `serverless`"

  validation {
    condition     = can(regex("^(parallelquery|provisioned)$", var.engine_mode))
    error_message = "Invalid engine mode."
  }
}

variable "engine_version" {
  type        = string
  default     = ""
  description = "The version of the database engine to use. See `aws rds describe-db-engine-versions` "
}

variable "engine" {
  type        = string
  default     = "aurora"
  description = "The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-mysql`, `aurora-postgresql`"
}
variable "iam_roles" {
  type        = list(string)
  description = "A List of ARNs for the IAM roles to associate to the RDS Cluster."
  default     = []
}

variable "kms_key_id" {
  type        = string
  description = "The ARN for the KMS encryption key. When specifying `kms_key_arn`, `storage_encrypted` needs to be set to `true`"
  default     = ""
}

variable "port" {
  type        = number
  default     = 5432
  description = "The port on which the DB accepts connections."
}

variable "storage_encrypted" {
  type        = bool
  description = "pecifies whether the DB cluster is encrypted. The default is false for provisioned engine_mode and true for serverless engine_mode. When restoring an unencrypted snapshot_identifier, the kms_key_id argument must be provided to encrypt the restored cluster"
  default     = false
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "List of VPC security groups to associate with the Cluster"
  default     = []
}

variable "final_snapshot_identifier_suffix" {
  type        = string
  description = "Final Snapshot identifier suffix"
  default     = "final-snapshot"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted"
  default     = false
}

variable "backup_retention_period" {
  type        = number
  default     = 7
  description = "Number of days to retain backups for"
}

variable "preferred_backup_window" {
  type        = string
  description = "Daily time range during which the backups happen"
  default     = "04:00-06:00"
}

variable "allow_major_version_upgrade" {
  type        = bool
  default     = false
  description = "Enable to allow major engine version upgrades when changing engine versions"
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Set of log types to export to cloudwatch. If omitted, no logs will be exported. The following log types are supported: audit, error, general, slowquery, postgresql (PostgreSQL"
  type        = set(string)
  default     = []
}

variable "iam_database_authentication_enabled" {
  type        = bool
  description = "Specifies whether or not mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled."
  default     = false
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of VPC subnet IDs"
}

variable "is_serverless" {
  type        = bool
  description = "Serverless engine mode "
  default     = false
}

variable "db_cluster_instances" {
  type        = any
  default     = {}
  description = "Aurora RDS Cluster Instances Configuration"
}

variable "parameter_group_name" {
  type        = string
  description = "The name of the DB parameter group. If omitted, Terraform will assign a random, unique name."
  default     = ""
}

variable "parameter_group_family" {
  type        = string
  default     = "aurora5.6"
  description = "The family of the DB cluster parameter group"
}

variable "parameter_group_description" {
  type        = string
  default     = "Aurora RDS Parameter Group"
  description = "Aurora RDS Parameter Group"
}

variable "parameter_group_parameters" {
  type        = any
  description = "Parameter Groups Parameters"
  default     = {}
}

variable "create_parameter_group" {
  type        = bool
  description = "Wheter to created a parameter group for Aurora RDS Cluster/Database"
  default     = false
}

##### KMS KEY variables
variable "kms_key_present" {
  type        = bool
  default     = true
  description = "Wheter to provide a KMS Key for Aurora RDS Cluster"
}

variable "key_usage" {
  type        = string
  description = "Specifies the intended use of the key. Valid values: ENCRYPT_DECRYPT, SIGN_VERIFY, or GENERATE_VERIFY_MAC. Defaults to ENCRYPT_DECRYPT"
  default     = "ENCRYPT_DECRYPT"
}

variable "customer_master_key_spec" {
  type        = string
  description = " Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, HMAC_256, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, or ECC_SECG_P256K1"
  default     = "SYMMETRIC_DEFAULT"
}

variable "kms_key_policy" {
  type        = string
  default     = ""
  description = "A valid policy JSON document. Although this is a key policy, not an IAM policy, an aws_iam_policy_document, in the form that designates a principal, can be used"
}

variable "deletion_window_in_days" {
  type        = string
  default     = 7
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key"
}

variable "is_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether the key is enabled."
}

variable "enable_key_rotation" {
  type        = bool
  default     = true
  description = "Specifies whether key rotation is enabled."
}

variable "kms_key_name" {
  type        = string
  description = "KMS Key Name Tag"
  default     = ""
}

variable "custom_kms_policies" {
  type        = list(string)
  description = "A list of KMS Policies that should be applied to KMS Key"
  default     = []
}

### Secrets Manager Variables 


variable "create_secret" {
  type        = bool
  default     = true
  description = "Enable this to create a Secrets Manager Secret that will store some terraform outputs"
}
variable "secret_name" {
  type        = string
  description = "Secrets Manager Secrets name"
  default     = ""
}

variable "secrets_manager_kms_key_id" {
  type        = string
  description = "ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in this secret. If you don't specify this value, then Secrets Manager defaults to using the AWS account's default KMS key (the one named aws/secretsmanager). If the default KMS key with that name doesn't yet exist, then AWS Secrets Manager creates it for you automatically the first time."
  default     = ""
}

variable "secret_policy" {
  type        = string
  description = "Valid JSON document representing a resource policy."
  default     = ""
}

variable "custom_secret_policies" {
  type        = list(string)
  default     = []
  description = "A list of policies that should be applied to Secrets Manager Secret"
}
#### Security Group Variables

variable "create_security_group" {
  description = "Determines whether to create security group for RDS cluster"
  type        = bool
  default     = true
}

variable "security_group_name" {
  type        = string
  description = "RDS Security Group Name"
  default     = ""
}

variable "security_group_use_name_prefix" {
  description = "Determines whether the security group name (`name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "security_group_description" {
  description = "The description of the security group. If value is set to empty string it will contain cluster name in the description"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = ""
}


variable "security_group_rules" {
  description = "A map of security group  rule definitions to add to the security group created"
  type        = map(any)
  default     = {}
}

variable "cluster_security_group_tags" {
  description = "A map of tags that should be applied to RDS Security Group"
  default     = {}
  type        = map(any)
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of general tags that will be applied to AWS Resources"
}


variable "account_id" {
  type        = string
  description = "AWS Account ID"
  default     = ""
}

variable "principals" {
  type        = list(string)
  description = "Principals that should have access to KMS / Secrets Manager"
  default     = []
}