resource "ibm_resource_instance" "es_instance_1" {
  count             = var.enable_event_streams_service ? 1 : 0
  name              = var.es_kafka_service_name
  service           = "messagehub"
  plan              = var.es_kafka_plan
  location          = var.region
  resource_group_id = data.ibm_resource_group.group.id
}

resource "ibm_event_streams_topic" "es_topic_1" {
  count                = var.enable_event_streams_service ? 1 : 0
  resource_instance_id = ibm_resource_instance.es_instance_1[count.index].id
  name                 = var.es_kafka_topic_name
  partitions           = var.es_kafka_topic_partitions
  config = {
    "cleanup.policy"   = var.es_kafka_topic_cleanup_policy
    "retention.ms"     = var.es_kafka_topic_retention_ms
    "retention.bytes"  = var.es_kafka_topic_retention_bytes
    "segment.bytes"    = var.es_kafka_topic_segment_bytes
  }
}
