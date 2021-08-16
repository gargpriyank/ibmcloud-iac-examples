# Infrastructure as Code ROKS VPC

This directory contains the terraform code to provision IBM cloud VPC infrastructure Gen 2, Red Hat OpenShift Kubernetes Service cluster in VPC, Public Gateway, VPN
Gateway to connect to other VPC network or on-premise network, IBM Databases for MongoDB (configurable to any other IBM database service) and IBM
Event Streams (Kafka).

![Network Architecture](https://github.com/gargpriyank/ibmcloud-iac-examples/blob/master/roks-vpc/images/Network_Architecture.png)

This code provides the flexibility to use custom CIDR for address prefix (enable_custom_address_prefix) and subnets
(enable_custom_subnet). If custom flag is set to false, it will create an address prefix and subnets using 10.0.*.0. Public Gateway
(enable_public_gateway), VPN Gateway (enable_vpn), IBM Databases for MongoDB (enable_db_service) and IBM Event Streams
(enable_event_streams_service) are optional and can be set as false to not to provision it.

## Navigation

- [Prerequisites](#prerequisites)
- [Initialize](#initialize)
- [Using Terraform](#using-terraform)
  <br> or,
- (Recommended) [Using Schematics](#using-schematics)
- [Validation](#validation)

## Prerequisites

The requirements are documented in the
[Environment Setup](https://github.com/gargpriyank/ibmcloud-iac-examples/blob/master/setup-environment.md). It includes:

- Have an IBM Cloud account with required privileges
- [Install IBM Cloud CLI](https://github.com/gargpriyank/ibmcloud-iac-examples/blob/master/setup-environment.md#install-ibm-cloud-cli)
- [Install the IBM Cloud CLI Plugins](https://github.com/gargpriyank/ibmcloud-iac-examples/blob/master/setup-environment.md#ibm-cloud-cli-plugins)
  `infrastructure-service`, `schematics` and `container-registry`.
- [Log in to IBM Cloud with the CLI](https://github.com/gargpriyank/ibmcloud-iac-examples/blob/master/setup-environment.md#login-to-ibm-cloud)
- [Install Terraform](https://github.com/gargpriyank/ibmcloud-iac-examples/blob/master/setup-environment.md#install-terraform)
- [Configure access to IBM Cloud](https://github.com/gargpriyank/ibmcloud-iac-examples/blob/master/setup-environment.md#configure-access-to-ibm-cloud) for
  Terraform and the IBM Cloud CLI
- [Install IBM Cloud Terraform Provider](https://github.com/gargpriyank/ibmcloud-iac-examples/blob/master/setup-environment.md#configure-access-to-ibm-cloud)
- Install the following tools:
  - [IBM Cloud Pak CLI (cloudctl) and OpenShift client CLI (oc)](https://www.ibm.com/support/knowledgecenter/SSFKVV_4.2/cli/cloudctl_oc_cli.html)
  - [docker](https://www.ibm.com/links?url=https%3A%2F%2Fdocs.docker.com%2Fget-docker%2F)

> The IBM Cloud Terraform provider must be version 0.13 or later. This example is using Terraform version 1.0.

## Initialize

1. Create `workspace` directory in your local linux/mac box. Download **roks-vpc** project code.

    ```markdown
    mkdir <your_home_dir>/workspace
    cd <your_home_dir>/workspace
    git clone https://github.com/gargpriyank/ibmcloud-iac-examples.git
    cd ibmcloud-iac-examples/roks-vpc
    ```

2. Execute the commands in below to validate the ibm cloud, terraform and schematics CLI version.

    ```markdown
    ibmcloud --version
    ibmcloud plugin show infrastructure-service | head -3
    ibmcloud plugin show schematics | head -3
    ibmcloud target
    terraform version
    ls ~/.terraform.d/plugins/terraform-provider-ibm_*
    echo $IC_API_KEY
    ```

3. Create the IBM Cloud API Key as in below.

    ```markdown
    # Create a new one and export it as environment variable
    ibmcloud iam api-key-create TerraformKey -d "API Key for Terraform" --file ~/ibm_api_key.json
    export IC_API_KEY=$(grep '"apikey":' ~/ibm_api_key.json | sed 's/.*: "\(.*\)".*/\1/')
    ```

## Using Terraform

1. A sample `terraform.tfvars` file is provided with this example. This file creates resources in Frankfurt region in single zone. A multi-zone
   sample file is available in **multizone** directory.

   > Note: Please replace the values of the variables as per your project requirement. It is recommended not to commit `terraform.tfvars` file
   > since it may contain sensitive information like password.**

    ```markdown
    project_name                   = "iac-example"
    environment                    = "dev"
    resource_group                 = "iac-example-dev-rg"
    region                         = "eu-de"
    vpc_zone_names                 = ["eu-de-1", "eu-de-2"]
    flavors                        = ["mx2.4x32", "mx2.4x32"]
    workers_count                  = [2, 1]
    ...
    ```

2. Set the api key variables **iaas_classic_username** and **iaas_classic_api_key**. Use below command to get the value of VLAN variables
   **public_vlan_id**, **private_vlan_id**, **additional_zone_public_service_endpoint** and **additional_zone_private_service_endpoint**.

    ```markdown
    ibmcloud sl vlan list -d <zone_name>
    ```

3. Execute below Terraform commands to provision the infrastructure.

    ```markdown
    terraform init  # Initialize the terraform working directory.
    terraform plan  # Create the terraform execution plan.
    terraform apply  # Apply the terraform plan to reach to the desired state.
    ```

4. Optional: In case you want to clean up the infrastructure, execute below Terraform command.

    ```markdown
    terraform destroy  # Destroy the infrastructure produced by terraform.
    ```

## Using Schematics

Schematics delivers the Terraform as a Service. Below are the steps to create and run schematics workspace to provision cloud resources.

1. A sample `workspace.json` file is provided with this example. This file creates resources in Frankfurt region in single zone. A multi-zone
   sample file is available in **multizone** directory.

   > Note: Please replace the values of the variables as per your project requirement. It is recommended not to commit `workspace.json` file
   > since it may contain sensitive information like password.**

    ```markdown
    ...
    "template_data": [{
        "folder": ".",
        "type": "terraform_v1.0",
        "variablestore": [{
          "name": "project_name",
          "value": "iac-example",
          "type": "string"
        },
          {
            "name": "environment",
            "value": "dev",
            "type": "string"
          },
          {
            "name": "resource_group",
            "value": "iac-example-rg",
            "type": "string"
          },
          {
            "name": "region",
            "value": "eu-de",
            "type": "string"
          },
          {
            "name": "vpc_zone_names",
            "value": "[\"eu-de-1\", \"eu-de-2\"]",
            "type": "list(string)"
          },
          {
            "name": "flavors",
            "value": "[\"mx2.4x32\", \"mx2.4x32\"]",
            "type": "list(string)"
          },
    ...
    ```      

2. Set the api key variables **iaas_classic_username** and **iaas_classic_api_key**. Use below command to get the value of VLAN variables
   **public_vlan_id**, **private_vlan_id**, **additional_zone_public_service_endpoint** and **additional_zone_private_service_endpoint**.

    ```markdown
    ibmcloud sl vlan list -d <zone_name>
    ```

3. Execute the below Schematics commands to create the plan and execute it. Set the api key variable `ibmcloud_api_key` before creating the plan.

    ```markdown
    # Create workspace:
    ibmcloud schematics workspace list
    ibmcloud schematics workspace new --file workspace.json  # Create the new workspace.
    ibmcloud schematics workspace list  # List all the workspaces.
    
    # Create plan: 
    ibmcloud schematics plan --id $WORKSPACE_ID  # Create the schematics plan.
    ibmcloud schematics logs --id $WORKSPACE_ID --act-id Activity_ID
    
    # Apply plan:
    ibmcloud schematics apply --id $WORKSPACE_ID  # Apply the schematics plan to reach to the desired state.
    ibmcloud schematics logs  --id $WORKSPACE_ID --act-id Activity_ID
    ```

4. Optional: Execute below Schematics command to destroy the infrastructure.

    ```markdown
    ibmcloud schematics destroy --id $WORKSPACE_ID  # Destroy the cloud resources associated to the workspace.
    ibmcloud schematics logs  --id $WORKSPACE_ID --act-id Activity_ID
    
    ibmcloud schematics workspace delete --id $WORKSPACE_ID  # Delete the schematics workspace.
    ibmcloud schematics workspace list
    ```

## Validation

After the infrastructure is provisioned, validate it using one of the Terraform or Schematics commands.

1. Execute the below commands to get the Terraform output and cluster info.

    ```markdown
    terraform output
    ibmcloud ks cluster config --cluster $(terraform output cluster_id)
    ```

2. Execute the below commands to get the Schematics output and cluster info.

    ```markdown
    ibmcloud schematics workspace list          # Identify the WORKSPACE_ID
    ibmcloud schematics workspace output --id $WORKSPACE_ID --json
    
    ibmcloud ks cluster config --cluster $(ibmcloud schematics output --id $WORKSPACE_ID --json | jq -r '.[].output_values[].cluster_id.value')
    ```

3. Use below `oc` commands to verify the cluster, node and pods info.

    ```markdown
    oc cluster-info
    oc get nodes
    oc get pods -A
    ```
