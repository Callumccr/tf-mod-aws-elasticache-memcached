# -----------------------------------------------------------------------------
# Variables: Common AWS Provider - Autoloaded from Terragrunt
# -----------------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region (e.g. ap-southeast-2). Autoloaded from region.tfvars."
  type        = string
  default     = ""
}

variable "aws_account_id" {
  description = "The AWS account id of the provider being deployed to (e.g. 12345678). Autoloaded from account.tfvars"
  type        = string
  default     = ""
}

variable "aws_assume_role_arn" {
  description = "(Optional) - ARN of the IAM role when optionally connecting to AWS via assumed role. Autoloaded from account.tfvars."
  type        = string
  default     = ""
}

variable "aws_assume_role_session_name" {
  description = "(Optional) - The session name to use when making the AssumeRole call."
  type        = string
  default     = ""
}

variable "aws_assume_role_external_id" {
  description = "(Optional) - The external ID to use when making the AssumeRole call."
  type        = string
  default     = ""
}

# -----------------------------------------------------------------------------
# Variables: TF-MOD-MEMCACHED - https://github.com/aciem-admin/tf-mod-memcached
# -----------------------------------------------------------------------------

variable "enabled" {
  description = "(Optional). A Switch that decides whether to create a terraform resource or run a provisioner. Default is true"
  type        = bool
  default     = true
}

variable "cluster_ids" {
  type        = list(string)
  description = "(Required) Group identifiers. ElastiCache converts these names to lowercase"
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "(Optional) - Security Group IDs to pass to the module security group for 'ingress' traffic"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "(Optional) - VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "(Optional) - Subnet IDs"
  default     = []
}

variable "service_ports" {
  type        = list(string)
  default     = ["11211", "-1", "1"]
  description = "(Optional) - MemcacheD service ports"
}

variable "max_item_size" {
  type        = number
  default     = 10485760
  description = "(Optional) - Max item size"
}

variable "maintenance_window" {
  type        = string
  default     = "wed:03:00-wed:04:00"
  description = "(Optional) - Maintenance window"
}

variable "cluster_size" {
  type        = number
  default     = 1
  description = "(Optional) - Cluster size"
}

variable "instance_type" {
  type        = string
  default     = "cache.t2.micro"
  description = "(Optional) - Elastic cache instance type"
}

variable "engine_version" {
  type        = string
  default     = "1.5.16"
  description = "(Optional) - Memcached engine version. For more info, see https://docs.aws.amazon.com/AmazonElastiCache/latest/mem-ug/supported-engine-versions.html"
}

variable "notification_topic_arn" {
  type        = string
  default     = ""
  description = "(Optional) - Notification topic arn"
}

variable "alarm_cpu_threshold_percent" {
  type        = number
  default     = 75
  description = "(Optional) - CPU threshold alarm level"
}

variable "alarm_memory_threshold_bytes" {
  type        = number
  default     = 10000000 # 10MB
  description = "Alarm memory threshold bytes"
}

variable "alarm_actions" {
  type        = list(string)
  default     = []
  description = "(Optional) - Alarm actions"
}

variable "apply_immediately" {
  type        = bool
  default     = true
  description = "(Optional) - Specifies whether any database modifications are applied immediately, or during the next maintenance window"
}

variable "availability_zones" {
  type        = list(string)
  description = "(Required) - List of Availability Zones for the cluster"
}

variable "zone_id" {
  type        = string
  default     = ""
  description = "(Optional) - Route53 DNS Zone ID"
}

variable "port" {
  type        = number
  default     = 11211
  description = "(Optional) - Memcached port"
}

variable "use_existing_security_groups" {
  type        = bool
  description = "(Optional) - Flag to enable/disable creation of Security Group in the module. Set to `true` to disable Security Group creation and provide a list of existing security Group IDs in `existing_security_groups` to place the cluster into"
  default     = false
}

variable "existing_security_groups" {
  type        = list(string)
  default     = []
  description = "(Optional) - List of existing Security Group IDs to place the cluster into. Set `use_existing_security_groups` to `true` to enable using `existing_security_groups` as Security Groups for the cluster"
}

variable "allowed_security_groups" {
  type        = list(string)
  default     = []
  description = "(Optional) - List of Security Group IDs that are allowed ingress to the cluster's Security Group created in the module"
}

variable "allow_all_egress" {
  type        = bool
  description = "(Required) - Whether to allow egress to (0.0.0.0/0) from the cluster"
  default     = true
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "(Optional) - List of CIDR blocks that are allowed ingress to the cluster's Security Group created in the module"
}

variable "elasticache_subnet_group_name" {
  type        = string
  description = "(Optional) - Subnet group name for the ElastiCache instance"
  default     = ""
}

variable "elasticache_parameter_group_family" {
  type        = string
  description = "(Optional) - ElastiCache parameter group family"
  default     = "memcached1.5"
}

# -----------------------------------------------------------------------------
# Variables: TF-MOD-LABEL
# -----------------------------------------------------------------------------

variable "namespace" {
  type        = string
  default     = ""
  description = "(Optional) - Namespace, which could be your abbreviated product team, e.g. 'rci', 'mi', 'hp', or 'core'"
}

variable "environment" {
  type        = string
  default     = ""
  description = "(Optional) - Environment, e.g. 'dev', 'qa', 'staging', 'prod'"
}

variable "name" {
  type        = string
  default     = ""
  description = "(Optional) - Solution name, e.g. 'vault', 'consul', 'keycloak', 'k8s', or 'baseline'"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "(Optional) - Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "(Optional) - Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) - Additional tags"
}