project_name                             = "iac-example"
environment                              = "dev"
resource_group                           = "iac-example-rg"
region                                   = "us-south"
additional_zone_names                    = []
datacenter                               = "dal10"
machine_type                             = "m3c.4x32"
workers_count                            = 2
hardware                                 = "shared"
public_vlan_id                           = "2953606"
private_vlan_id                          = "2953608"
enable_public_service_endpoint           = "true"
enable_private_service_endpoint          = "true"
add_zone_enable_public_service_endpoint  = ["true", "true"]
add_zone_enable_private_service_endpoint = ["true", "true"]
k8s_version                              = "4.4_openshift"
enable_db_service                        = false
db_name                                  = "iac-example-dev-mongodb"
db_plan                                  = "standard"
db_service_name                          = "databases-for-mongodb"
db_admin_password                        = "insecurepassword"
db_memory_allocation                     = 3072
db_disk_allocation                       = 61440
db_whitelist_ip_address                  = "0.0.0.0/0"
enable_event_streams_service             = true
es_kafka_plan                            = "standard"
es_kafka_service_name                    = "iac-example-kafka"
es_kafka_topic_name                      = "iac-example-topic-1"
es_kafka_topic_partitions                = 1
es_kafka_topic_cleanup_policy            = "compact,delete"
es_kafka_topic_retention_ms              = 86400000
es_kafka_topic_retention_bytes           = 1073741824
es_kafka_topic_segment_bytes             = 536870912
