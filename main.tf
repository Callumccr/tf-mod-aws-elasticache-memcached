#
# Security Group Resources
#
resource "aws_security_group" "default" {
  count  = var.enabled ? 1 : 0
  vpc_id = var.vpc_id
  name   = module.cache_label.id

  dynamic "ingress" {
    for_each = var.service_ports
    content {
      from_port       = service_ports.value
      to_port         = service_ports.value
      protocol        = "tcp"
      security_groups = element(var.security_group_ids, 0)
    }
  }

  dynamic "egress" {
    for_each = var.service_ports
    content {
      from_port       = service_ports.value
      to_port         = service_ports.value
      protocol        = "tcp"
      security_groups = element(var.security_group_ids, 0)
    }
  }
  tags = module.cache_label.tags
}

resource "aws_elasticache_subnet_group" "default" {
  count      = var.enabled == true && length(var.subnet_ids) > 0 ? 1 : 0
  name       = module.subnet_label.id
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_parameter_group" "default" {
  count  = var.enabled ? 1 : 0
  name   = module.parameter_group_label.id
  family = var.family

  dynamic "parameter" {
    for_each = var.parameter
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

resource "aws_elasticache_cluster" "default" {
  count                  = var.enabled ? length(var.memcached_names) : 0
  cluster_id             = "${module.cache_label.id}-${element(var.memcached_names, count.index)}"
  engine                 = "memcached"
  engine_version         = var.engine_version
  node_type              = var.instance_type
  num_cache_nodes        = var.cluster_size
  parameter_group_name   = join("", aws_elasticache_parameter_group.default.*.name)
  subnet_group_name      = join("", aws_elasticache_subnet_group.default.*.name)
  security_group_ids     = [join("", aws_security_group.default.*.id)]
  maintenance_window     = var.maintenance_window
  notification_topic_arn = var.notification_topic_arn
  port                   = var.port
  availability_zone      = element(var.availability_zones, var.cluster_size)
  tags                   = module.cache_label.tags

}

#
# CloudWatch Resources
#
resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count               = var.enabled ? length(var.memcached_names) : 0
  alarm_name          = "${module.cache_label.id}-${element(var.memcached_names, count.index)}-cpu-utilization"
  alarm_description   = "Redis cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"

  threshold = var.alarm_cpu_threshold_percent

  dimensions = {
    CacheClusterId = element(aws_elasticache_cluster.default.*.id, count.index)
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
  depends_on    = [aws_elasticache_cluster.default]
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  count               = var.enabled ? length(var.memcached_names) : 0
  alarm_name          = "${module.cache_label.id}-${element(var.memcached_names, count.index)}-freeable-memory"
  alarm_description   = "Redis cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"

  threshold = var.alarm_memory_threshold_bytes

  dimensions = {
    CacheClusterId = element(aws_elasticache_cluster.default.*.id, count.index)
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
  depends_on    = [aws_elasticache_cluster.default]
}

# module "dns" {
#   source  = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.3.0"
#   enabled = var.enabled && var.zone_id != "" ? true : false
#   name    = var.name
#   ttl     = 60
#   zone_id = var.zone_id
#   records = [join("", aws_elasticache_replication_group.default.*.primary_endpoint_address)]
# }
