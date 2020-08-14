project_name                   = "iac-example"
environment                    = "dev"
resource_group                 = "iac-example-dev-rg"
region                         = "eu-de"
vpc_zone_names                 = ["eu-de-1"]
flavors                        = ["mx2.4x32"]
workers_count                  = [2]
k8s_version                    = "4.3_openshift"
db_name                        = "iac-example-dev-mongodb"
db_plan                        = "standard"
db_service_name                = "databases-for-mongodb"
db_admin_password              = "password123"
db_memory_allocation           = 3072
db_disk_allocation             = 61440
db_whitelist_ip_address        = "0.0.0.0/0"
es_kafka_plan                  = "standard"
es_kafka_service_name          = "iac-example-kafka"
es_kafka_topic_name            = "iac-example-topic-1"
es_kafka_topic_partitions      = 1
es_kafka_topic_cleanup_policy  = "compact,delete"
es_kafka_topic_retention_ms    = 86400000
es_kafka_topic_retention_bytes = 1073741824
es_kafka_topic_segment_bytes   = 536870912
vpn_gateway_name               = "iac-example-dev-vpn-gateway"
vpn_connection_name            = "iac-example-dev-vpn-connection"
vpn_connection_pre_shared_key  = "vpndemo123"
vpn_connection_interval        = 30
vpn_connection_timeout         = 120
vpn_connection_admin_state_up  = true
vpn_connection_action          = "restart"
vpn_peer_cidr                  = ["192.168.0.0/24"]
vpn_peer_public_address        = "52.116.137.73"
