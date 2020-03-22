## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 >= 2.7.0 |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| availability\_zones | (Required) - List of Availability Zones for the cluster | `list(string)` | n/a | yes |
| cluster\_ids | (Required) Group identifiers. ElastiCache converts these names to lowercase | `list(string)` | n/a | yes |
| alarm\_actions | (Optional) The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Name (ARN). | `list(string)` | `[]` | no |
| alarm\_cpu\_threshold\_percent | (Optional) - CPU threshold alarm level | `number` | `75` | no |
| alarm\_memory\_threshold\_bytes | Alarm memory threshold bytes | `number` | `10000000` | no |
| allow\_all\_egress | (Required) - Whether to allow egress to (0.0.0.0/0) from the cluster | `bool` | `true` | no |
| allowed\_cidr\_blocks | (Optional) - List of CIDR blocks that are allowed ingress to the cluster's Security Group created in the module | `list(string)` | `[]` | no |
| allowed\_security\_groups | (Optional) - List of Security Group IDs that are allowed ingress to the cluster's Security Group created in the module | `list(string)` | `[]` | no |
| apply\_immediately | (Optional) - Specifies whether any database modifications are applied immediately, or during the next maintenance window | `bool` | `true` | no |
| attributes | (Optional) - Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| aws\_account\_id | The AWS account id of the provider being deployed to (e.g. 12345678). Autoloaded from account.tfvars | `string` | `""` | no |
| aws\_assume\_role\_arn | (Optional) - ARN of the IAM role when optionally connecting to AWS via assumed role. Autoloaded from account.tfvars. | `string` | `""` | no |
| aws\_assume\_role\_external\_id | (Optional) - The external ID to use when making the AssumeRole call. | `string` | `""` | no |
| aws\_assume\_role\_session\_name | (Optional) - The session name to use when making the AssumeRole call. | `string` | `""` | no |
| aws\_region | The AWS region (e.g. ap-southeast-2). Autoloaded from region.tfvars. | `string` | `""` | no |
| cluster\_size | (Optional) - Cluster size | `number` | `1` | no |
| delimiter | (Optional) - Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes` | `string` | `"-"` | no |
| elasticache\_parameter\_group\_family | (Optional) - ElastiCache parameter group family | `string` | `"memcached1.5"` | no |
| elasticache\_subnet\_group\_name | (Optional) - Subnet group name for the ElastiCache instance | `string` | `""` | no |
| enabled | (Optional). A Switch that decides whether to create a terraform resource or run a provisioner. Default is true | `bool` | `true` | no |
| engine\_version | (Optional) - Memcached engine version. For more info, see https://docs.aws.amazon.com/AmazonElastiCache/latest/mem-ug/supported-engine-versions.html | `string` | `"1.5.16"` | no |
| environment | (Optional) - Environment, e.g. 'dev', 'qa', 'staging', 'prod' | `string` | `""` | no |
| existing\_security\_groups | (Optional) - List of existing Security Group IDs to place the cluster into. Set `use_existing_security_groups` to `true` to enable using `existing_security_groups` as Security Groups for the cluster | `list(string)` | `[]` | no |
| instance\_type | (Optional) - Elastic cache instance type | `string` | `"cache.t2.micro"` | no |
| maintenance\_window | (Optional) - Maintenance window | `string` | `"wed:03:00-wed:04:00"` | no |
| max\_item\_size | (Optional) - Max item size | `number` | `10485760` | no |
| name | (Optional) - Solution name, e.g. 'vault', 'consul', 'keycloak', 'k8s', or 'baseline' | `string` | `""` | no |
| namespace | (Optional) - Namespace, which could be your abbreviated product team, e.g. 'rci', 'mi', 'hp', or 'core' | `string` | `""` | no |
| notification\_topic\_arn | (Optional) - Notification topic arn | `string` | `""` | no |
| ok\_actions | (Optional) - Alarm actions | `list(string)` | `[]` | no |
| port | (Optional) - Memcached port | `number` | `11211` | no |
| security\_group\_ids | (Optional) - Security Group IDs to pass to the module security group for 'ingress' traffic | `list(string)` | `[]` | no |
| subnet\_ids | (Optional) - Subnet IDs | `list(string)` | `[]` | no |
| tags | (Optional) - Additional tags | `map(string)` | `{}` | no |
| use\_existing\_security\_groups | (Optional) - Flag to enable/disable creation of Security Group in the module. Set to `true` to disable Security Group creation and provide a list of existing security Group IDs in `existing_security_groups` to place the cluster into | `bool` | `false` | no |
| vpc\_id | (Optional) - VPC ID | `string` | `""` | no |
| zone\_id | (Optional) - Route53 DNS Zone ID | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_address | Cluster address/es |
| cluster\_configuration\_endpoint | Cluster configuration endpoint/s |
| cluster\_id | Cluster ID/s |
| cluster\_urls | Cluster URLs |
| hostname | Cluster hostname |
| security\_group\_id | Security Group ID |

