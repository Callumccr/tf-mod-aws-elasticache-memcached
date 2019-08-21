output "cache_nodes" {
  value       = formatlist("%s", aws_elasticache_cluster.default.*.id)
  description = "List of node objects including id, address, port and availability_zone"
}

output "configuration_endpoint" {
  value       = formatlist("%s", aws_elasticache_cluster.default.*.configuration_endpoint)
  description = "(Memcached only) The configuration endpoint to allow host discovery."
}

output "cache_endpoint_map" {
  value = tomap({ "cms" = element(aws_elasticache_cluster.default.*.configuration_endpoint, 0), "session" = element(aws_elasticache_cluster.default.*.configuration_endpoint, 1) })
}


output "cluster_address" {
  value       = formatlist("%s", aws_elasticache_cluster.default.*.cluster_address)
  description = "(Memcached only) The DNS name of the cache cluster without the port appended."
}
