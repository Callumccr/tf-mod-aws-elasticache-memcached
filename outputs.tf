# -----------------------------------------------------------------------------
# Outputs: TF-MOD-MEMCACHED - https://github.com/aciem-admin/tf-mod-memcached
# -----------------------------------------------------------------------------

output "cache_nodes" {
  value       = formatlist("%s", aws_elasticache_cluster.default.*.id)
  description = "List of node objects including id, address, port and availability_zone"
}

output "configuration_endpoint" {
  value       = formatlist("%s", aws_elasticache_cluster.default.*.configuration_endpoint)
  description = "(Memcached only) The configuration endpoint to allow host discovery."
}

output "cache_endpoint_map" {
  value = tomap(
    { "cms" = element(aws_elasticache_cluster.default.*.configuration_endpoint, 0), "session" = element(aws_elasticache_cluster.default.*.configuration_endpoint, 1) }
  )
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.default.*.id
}

output "cluster_address" {
  value       = formatlist("%s", aws_elasticache_cluster.default.*.cluster_address)
  description = "(Memcached only) The DNS name of the cache cluster without the port appended."
}
