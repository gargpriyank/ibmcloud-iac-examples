output "cluster_id" {
  value = ibm_container_vpc_cluster.iac_iks_cluster.id
}

output "cluster_name" {
  value = ibm_container_vpc_cluster.iac_iks_cluster.name
}

output "entrypoint" {
  value = ibm_container_vpc_cluster.iac_iks_cluster.public_service_endpoint_url
}

output "database_connection_string" {
  value = ibm_database.iac_app_db_instance.connectionstrings.0.composed
}

output "es_kafka_id" {
  value = ibm_resource_instance.es_instance_1.id
}
