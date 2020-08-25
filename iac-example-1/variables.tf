variable "project_name" {}
variable "environment" {}

variable "resource_group" {
  type    = string
  default = "my-resources"
}

variable "region" {
  type    = string
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
  type    = string
  default = "4.4_openshift"
}

variable "db_name" {
  type    = string
  default = "sampledb"
}

variable "db_plan" {
  type    = string
  default = "standard"
}

variable "db_service_name" {
  type    = string
  default = "databases-for-mongodb"
}

variable "db_admin_password" {
  type    = string
  default = "insecurepassword"
}

variable "db_memory_allocation" {
  type    = number
  default = 3072
}

variable "db_disk_allocation" {
  type    = number
  default = 61440
}

variable "db_whitelist_ip_address" {
  type    = string
  default = "0.0.0.0/0"
}

variable "es_kafka_service_name" {
  type    = string
  default = "event-service-kafka"
}

variable "es_kafka_plan" {
  type    = string
  default = "standard"
}

variable "es_kafka_topic_name" {
  type    = string
  default = "topic-1"
}

variable "es_kafka_topic_partitions" {
  type    = number
  default = 1
}

variable "es_kafka_topic_cleanup_policy" {
  type    = string
  default = "compact,delete"
}

variable "es_kafka_topic_retention_ms" {
  type    = number
  default = 86400000
}

variable "es_kafka_topic_retention_bytes" {
  type    = number
  default = 1073741824
}

variable "es_kafka_topic_segment_bytes" {
  type    = number
  default = 536870912
}

variable "vpn_connection_pre_shared_key" {
  type    = list(string)
  default = ["insecuresharedkey"]
}

variable "vpn_connection_interval" {
  type    = list(number)
  default = [30]
}

variable "vpn_connection_timeout" {
  type    = list(number)
  default = [120]
}

variable "vpn_connection_admin_state_up" {
  type    = list(bool)
  default = [true]
}

variable "vpn_connection_action" {
  type    = list(string)
  default = ["restart"]
}

variable "vpn_peer_cidr" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "vpn_peer_public_address" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

locals {
  max_size = length(var.vpc_zone_names)
}
