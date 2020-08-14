variable "project_name" {}
variable "environment" {}

variable "resource_group" {
  default = "my-resources"
}

variable "region" {
  default = "us-south"
}

variable "vpc_zone_names" {
  type    = list(string)
  default = ["us-south-1", "us-south-2"]
}

variable "flavors" {
  type    = list(string)
  default = ["mx2.4x32", "mx2.4x32"]
}

variable "workers_count" {
  type    = list(number)
  default = [2, 2]
}

variable "k8s_version" {
  default = "4.4_openshift"
}

variable "db_name" {
  default = "sampledb"
}

variable "db_plan" {
  default = "standard"
}

variable "db_service_name" {
  default = "databases-for-mongodb"
}

variable "db_admin_password" {
  default = "insecure_password"
}

variable "db_memory_allocation" {
  default = 3072
}

variable "db_disk_allocation" {
  default = 61440
}

variable "db_whitelist_ip_address" {
  default = "0.0.0.0/0"
}

variable "es_kafka_service_name" {
  default = "event-service-kafka"
}

variable "es_kafka_plan" {
  default = "standard"
}

variable "es_kafka_topic_name" {
  default = "topic-1"
}

variable "es_kafka_topic_partitions" {
  default = 1
}

variable "es_kafka_topic_cleanup_policy" {
  default = "compact,delete"
}

variable "es_kafka_topic_retention_ms" {
  default = 86400000
}

variable "es_kafka_topic_retention_bytes" {
  default = 1073741824
}

variable "es_kafka_topic_segment_bytes" {
  default = 536870912
}

variable "vpn_gateway_name" {
  default = "sample-vpn-gateway"
}

variable "vpn_connection_name" {
  default = "sample-vpn-connection"
}

variable "vpn_connection_pre_shared_key" {
  default = "vpmdemo123"
}

variable "vpn_connection_interval" {
  default = 30
}

variable "vpn_connection_timeout" {
  default = 120
}

variable "vpn_connection_admin_state_up" {
  type    = bool
  default = true
}

variable "vpn_connection_action" {
  default = "restart"
}

variable "vpn_peer_cidr" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "vpn_peer_public_address" {
  default = "0.0.0.0/0"
}

locals {
  max_size = length(var.vpc_zone_names)
}
