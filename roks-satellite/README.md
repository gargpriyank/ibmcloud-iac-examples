# Infrastructure as Code ROKS Satellite

This directory contains the terraform and schematics code to provision Red Hat OpenShift Kubernetes Service on IBM Cloud Satellite deployed on IBM 
Cloud Virtual Servers inside IBM Virtual Private Cloud.

## Navigation

- [Prerequisites](#prerequisites)
- [Initialize](#initialize)
- [Using Terraform](#using-terraform)
  <br> or,
- (Recommended) [Using Schematics](#using-schematics)

## Prerequisites

The requirements are documented in the
[Environment Setup](https://github.com/gargpriyank/ibmcloud-iac-examples/blob/master/setup-environment.md). It includes:

- Have an IBM Cloud account with required privileges
- [Install IBM Cloud CLI](https://github.com/gargpriyank/ibmcloud-iac-examples/blob/master/setup-environment.md#install-ibm-cloud-cli)
- [Install the IBM Cloud CLI Plugin](https://github.com/gargpriyank/ibmcloud-iac-examples/blob/master/setup-environment.md#ibm-cloud-cli-plugins)
  `schematics`.
- [Log in to IBM Cloud with the CLI](https://github.com/gargpriyank/ibmcloud-iac-examples/blob/master/setup-environment.md#login-to-ibm-cloud)
- [Install Terraform](https://github.com/gargpriyank/ibmcloud-iac-examples/blob/master/setup-environment.md#install-terraform)
- [Install IBM Cloud Terraform Provider](https://github.com/IBM-Cloud/terraform-provider-ibm)

> The IBM Cloud Terraform provider must be version 0.13.0 or later. This example is using Terraform version 0.13.0.

## Initialize

1. Create `workspace` directory in your local linux/mac box. Download **roks-satellite** project code.

    ```markdown
    mkdir <your_home_dir>/workspace
    cd <your_home_dir>/workspace
    git clone https://github.com/gargpriyank/ibmcloud-iac-examples.git
    cd ibmcloud-iac-examples/roks-satellite
    ```

2. Execute the commands in below to validate the ibm cloud, terraform and schematics CLI version.

    ```markdown
    ibmcloud --version
    ibmcloud plugin show schematics | head -3
    ibmcloud target
    terraform version
    echo $IC_API_KEY
    ```

3. Create the IBM Cloud API Key as in below.

    ```markdown
    # Create a new one and export it as environment variable
    ibmcloud iam api-key-create TerraformKey -d "API Key for Terraform" --file ~/ibm_api_key.json
    export IC_API_KEY=$(grep '"apikey":' ~/ibm_api_key.json | sed 's/.*: "\(.*\)".*/\1/')
    ```

## Using Terraform

1. A sample `terraform.tfvars` file is provided with this example. This file creates resources in Washington DC region in single zone. To access 
   the OpenShift cluster from the public network, make sure you set `cluster_enable_public_access` value to `true`.

   > Note: Please replace the values of the variables as per your project requirement. It is recommended not to commit `terraform.tfvars` file
   > since it may contain sensitive information like password.**

    ```markdown
    project_name                   = "iac-example"
    environment                    = "dev"
    resource_group                 = "iac-example-dev-rg"
    region                         = "us-east"
    ...
    ```

2. Execute below Terraform commands to provision the infrastructure.

    ```markdown
    terraform init  # Initialize the terraform working directory and modules.
    terraform plan  # Create the terraform execution plan.
    terraform apply  # Apply the terraform plan to reach to the desired state.
    ```

3. Optional: In case you want to clean up the infrastructure, execute below Terraform command.

    ```markdown
    terraform destroy  # Destroy the infrastructure produced by terraform.
    ```
4. After OpenShift cluster is provisioned, follow the [documentation](https://cloud.ibm.com/docs/openshift?topic=openshift-access_cluster#sat_public_access) 
   to access cluster from the public network.

## Using Schematics

Schematics delivers the Terraform as a Service. Below are the steps to create and run schematics workspace to provision cloud resources.

1. A sample `workspace.json` file is provided with this example.

   > Note: Please replace the values of the variables as per your project requirement. It is recommended not to commit `workspace.json` file
   > since it may contain sensitive information like password.**

    ```markdown
    ...
    "template_data": [{
        "folder": ".",
        "type": "terraform_v1.0.*",
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
            "value": "iac-example-dev-rg",
            "type": "string"
          },
          {
            "name": "region",
            "value": "us-east",
            "type": "string"
          },
    ...
    ```
   
2. Execute the below Schematics commands to create the plan and execute it. Set the api key variable `ibmcloud_api_key` before creating the plan.

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

3. Optional: Execute below Schematics command to destroy the infrastructure.

    ```markdown
    ibmcloud schematics destroy --id $WORKSPACE_ID  # Destroy the cloud resources associated to the workspace.
    ibmcloud schematics logs  --id $WORKSPACE_ID --act-id Activity_ID
    
    ibmcloud schematics workspace delete --id $WORKSPACE_ID  # Delete the schematics workspace.
    ibmcloud schematics workspace list
    ```
4. After OpenShift cluster is provisioned, follow the [documentation](https://cloud.ibm.com/docs/openshift?topic=openshift-access_cluster#sat_public_access)
   to access cluster from the public network.