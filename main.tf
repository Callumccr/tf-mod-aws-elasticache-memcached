resource "null_resource" "cluster_urls" {
  count = var.enabled ? var.cluster_size : 0

  triggers = {
    name = "${replace(
      join("", aws_elasticache_cluster.default.*.cluster_address),
      ".cfg.",
      format(".%04d.", count.index + 1)
    )}:${var.port}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

#
# Security Group Resources
#
resource "aws_security_group" "default" {
  count  = var.enabled && var.use_existing_security_groups == false ? 1 : 0
  vpc_id = var.vpc_id
  name   = module.sg_label.id

  dynamic "ingress" {
    for_each    = var.service_ports
    iterator    = ingress
    description = "Allow inbound traffic from existing Security Groups"
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = length(var.allowed_security_groups) > 0 ? element(var.allowed_security_groups, count.index) : null
    }
  }

  dynamic "ingress" {
    for_each    = var.allowed_cidr_blocks
    iterator    = ingress
    description = "Allow inbound traffic to internal CIDR ranges"
    content {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      cidr_blocks = length(var.allowed_cidr_blocks) > 0 ? [ingress.value] : null
    }
  }

  dynamic "egress" {
    for_each    = var.service_ports
    iterator    = egress
    description = "Allow egress traffic to existing Security Groups"
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = length(var.allowed_security_groups) > 0 ? element(var.allowed_security_groups, count.index) : null
    }
  }

  egress {
    description = "Allow all egress traffic"
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "tcp"
    cidr_blocks = var.allow_all_egress ? ["0.0.0.0/0"] : null
  }

  tags = module.sg_label.tags
}

resource "aws_elasticache_subnet_group" "default" {
  count      = var.enabled == true && length(var.subnet_ids) > 0 ? 1 : 0
  name       = module.subnet_label.id
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_parameter_group" "default" {
  count  = var.enabled ? 1 : 0
  name   = module.parameter_group_label.id
  family = var.elasticache_parameter_group_family

  parameter {
    name  = "max_item_size"
    value = var.max_item_size
  }
}




resource "aws_elasticache_cluster" "default" {
  count                        = var.enabled ? length(var.memcached_names) : 0
  cluster_id                   = "${module.label.id}-${element(var.memcached_names, count.index)}"
  engine                       = "memcached"
  engine_version               = var.engine_version
  node_type                    = var.instance_type
  num_cache_nodes              = var.cluster_size
  parameter_group_name         = join("", aws_elasticache_parameter_group.default.*.name)
  subnet_group_name            = join("", aws_elasticache_subnet_group.default.*.name)
  security_group_ids           = [join("", aws_security_group.default.*.id)]
  maintenance_window           = var.maintenance_window
  notification_topic_arn       = var.notification_topic_arn
  port                         = var.port
  az_mode                      = var.cluster_size == 1 ? "single-az" : "cross-az"
  preferred_availability_zones = slice(var.availability_zones, 0, var.cluster_size)
  tags                         = module.label.tags

}

#
# CloudWatch Resources
#
resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count               = var.enabled ? length(var.memcached_names) : 0
  alarm_name          = "${module.label.id}-${element(var.memcached_names, count.index)}-cpu-utilization"
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
  alarm_name          = "${module.label.id}-${element(var.memcached_names, count.index)}-freeable-memory"
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

module "dns" {
  source  = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.3.0"
  enabled = var.enabled && var.zone_id != "" ? true : false
  name    = var.name
  ttl     = 60
  zone_id = var.zone_id
  records = [join("", aws_elasticache_cluster.default.*.cluster_address)]
}
