resource "ibm_resource_instance" "iac_app_db_instance" {
  name              = var.db_name
  service           = var.db_service_name
  plan              = var.db_plan
  location          = var.region
  resource_group_id = data.ibm_resource_group.group.id
}