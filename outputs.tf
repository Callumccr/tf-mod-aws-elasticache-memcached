# -----------------------------------------------------------------------------
# Outputs: TF-MOD-MEMCACHED 
# -----------------------------------------------------------------------------

output "cluster_id" {
  value       = [aws_elasticache_cluster.default.*.id]
  description = "Cluster ID/s"
}

output "security_group_id" {
  value       = [aws_security_group.default.*.id]
  description = "Security Group ID"
}

output "cluster_address" {
  value       = [aws_elasticache_cluster.default.*.cluster_address]
  description = "Cluster address/es"
}

output "cluster_configuration_endpoint" {
  value       = [aws_elasticache_cluster.default.*.configuration_endpoint]
  description = "Cluster configuration endpoint/s"
}

output "hostname" {
  value       = module.dns.hostname
  description = "Cluster hostname"
}

output "cluster_urls" {
  value       = null_resource.cluster_urls.*.triggers.name
  description = "Cluster URLs"
}