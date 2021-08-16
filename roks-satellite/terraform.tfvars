project_name                 = "iac-example"
environment                  = "dev"
resource_group               = "iac-example-dev-rg"
ibm_region                   = "us-east"
is_location_exist            = false
location                     = "iac-example-dev-sat"
cluster_name                 = "iac-example-dev-cluster"
cluster_zones                = ["us-east-1", "us-east-2", "us-east-3"]
enable_custom_address_prefix = true
address_prefix_cidr          = ["172.25.40.0/24", "172.25.41.0/24", "172.25.42.0/24"]
enable_custom_subnet         = true
subnet_cidr                  = ["172.25.40.0/26", "172.25.41.0/26", "172.25.42.0/26"]
enable_public_gateway        = true
managed_from                 = "wdc"
location_zones               = ["us-east-1", "us-east-2", "us-east-3"]
host_labels                  = ["env:dev"]
host_profile                 = "bx2-4x16"
cluster_host_profile         = "bx2-8x32"
host_count                   = 3
cluster_host_count           = 2
cluster_enable_config_admin  = true
ocp_version                  = "4.7_openshift"
host_provider                = "ibm"