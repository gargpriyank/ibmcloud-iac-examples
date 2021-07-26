resource "ibm_database" "iac_app_db_instance" {
  count                        = var.enable_db_service ? 1 : 0
  name                         = var.db_name
  plan                         = var.db_plan
  location                     = var.region
  service                      = var.db_service_name
  resource_group_id            = data.ibm_resource_group.group.id

  adminpassword                = var.db_admin_password
  members_memory_allocation_mb = var.db_memory_allocation
  members_disk_allocation_mb   = var.db_disk_allocation
  whitelist {
    address                    = var.db_whitelist_ip_address
    description                = "Access to this CIDR block only."
  }
}
