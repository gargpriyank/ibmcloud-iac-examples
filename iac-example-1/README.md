# Infrastructure as Code: Creating Red Hat OpenShift clusters on VPC Gen2

This directory contains terraform code to create IBM cloud VPC infrastructure, Red Hat OpenShift cluster in VPC, VPN Gateway to connect to other VPC or on-premise network, IBM Databases for MongoDB and IBM Event Streams (Kafka).  


- [Infrastructure as Code: Managing Container Registry (ICR) & Kubernetes Services (IKS) Resources](#infrastructure-as-code-managing-container-registry-icr--kubernetes-services-iks-resources)
  - [General Requirements](#general-requirements)
  - [How to use with Terraform](#how-to-use-with-terraform)
  - [How to use with Schematics](#how-to-use-with-schematics)
  - [How to use IBM Cloud Registry](#how-to-use-ibm-cloud-registry)
  - [Project Validation](#project-validation)

## General Requirements

Same for every pattern, the requirements are documented in the [Environment Setup](https://ibm.github.io/cloud-enterprise-examples/iac/setup-environment). It includes:

- Have an IBM Cloud account with required privileges
- [Install IBM Cloud CLI](https://ibm.github.io/cloud-enterprise-examples/iac/setup-environment#install-ibm-cloud-cli)
- [Install the IBM Cloud CLI Plugins](https://ibm.github.io/cloud-enterprise-examples/iac/setup-environment#ibm-cloud-cli-plugins) `infrastructure-service`, `schematics` and `container-registry`.
- [Login to IBM Cloud with the CLI](https://ibm.github.io/cloud-enterprise-examples/iac/setup-environment#login-to-ibm-cloud)
- [Install Terraform](https://ibm.github.io/cloud-enterprise-examples/iac/setup-environment#install-terraform)
- [Install IBM Cloud Terraform Provider](https://ibm.github.io/cloud-enterprise-examples/iac/setup-environment#configure-access-to-ibm-cloud)
- [Configure access to IBM Cloud](https://ibm.github.io/cloud-enterprise-examples/iac/setup-environment#configure-access-to-ibm-cloud) for Terraform and the IBM Cloud CLI
- (Optional) Install some utility tools such as: [jq](https://stedolan.github.io/jq/download/) and [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- (Optional) Install OpenShift CLI (OC) from OpenShift console by clicking ? button on the top right corner and selecting Command Line Tools option.

> For OpenShift clusters on VPC Gen 2, the IBM Cloud Terraform provider must be version 1.8.0 or later. This example is using Terraform version 0.12.0.

Executing these commands you are validating part of these requirements:

```bash
ibmcloud --version
ibmcloud plugin show infrastructure-service | head -3
ibmcloud plugin show schematics | head -3
ibmcloud target
terraform version
ls ~/.terraform.d/plugins/terraform-provider-ibm_*
echo $IC_API_KEY
```

If you have an API Key but is not set neither have the JSON file when it was created, you must recreate the key. Delete the old one if won't be in use anymore.

```bash
# Delete the old one, if won't be in use anymore
ibmcloud iam api-keys       # Identify your old API Key Name
ibmcloud iam api-key-delete NAME

# Create a new one and set it as environment variable
ibmcloud iam api-key-create TerraformKey -d "API Key for Terraform" --file ~/ibm_api_key.json
export IC_API_KEY=$(grep '"apikey":' ~/ibm_api_key.json | sed 's/.*: "\(.*\)".*/\1/')
```

## How to use with Terraform

A sample `terraform.tfvars` file is provided with this example. This file creates resources in Frankfurt region in single zone. A multizone sample file is available in multizone directory. 
#### Note: Please replace the values of the variables as per your project requirement.

```hcl-terraform
project_name                   = "iac-example"
environment                    = "dev"
resource_group                 = "iac-example-dev-rg"
region                         = "eu-de"
vpc_zone_names                 = ["eu-de-1"]
flavors                        = ["mx2.4x32"]
workers_count                  = [2]
...
```

Execute below Terraform commands to provision the infrastructure:

```bash
terraform init
terraform plan
terraform apply
```

Optional: In case you want to clean up the infrastructure, execute below Terraform command: 

```bash
terraform destroy
```

## How to use with Schematics

Schematics delivers Terraform as a Service. 

A sample `workspace-dev.json` file is provided with this example. This file creates resources in Frankfurt region in single zone. A multizone sample file is available in multizone directory.
#### Note: Please replace the values of the variables as per your project requirement.

```json
...
"template_data": [{
    "folder": ".",
    "type": "terraform_v0.12",
    "variablestore": [{
      "name": "project_name",
      "value": "iac-example-1",
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
        "value": "[\"eu-de-1\"]",
        "type": "list(string)"
      },
      {
        "name": "flavors",
        "value": "[\"mx2.4x32\"]",
        "type": "list(string)"
      },
...
```      

Execute the below Schematics commands:

```bash
# Create workspace:
ibmcloud schematics workspace list
ibmcloud schematics workspace new --file workspace-dev.json #Create dev environment workspace.
ibmcloud schematics workspace list          # Identify the WORKSPACE_ID

# Create plan: 
ibmcloud schematics plan --id $WORKSPACE_ID  # Identify the Activity_ID
ibmcloud schematics logs --id $WORKSPACE_ID --act-id Activity_ID

# Apply plan:
ibmcloud schematics apply --id $WORKSPACE_ID # Identify the Activity_ID
ibmcloud schematics logs  --id $WORKSPACE_ID --act-id Activity_ID
```

Optional: In case you want to clean up the infrastructure, execute below Schematics command:

```bash

ibmcloud schematics destroy --id $WORKSPACE_ID # Identify the Activity_ID
ibmcloud schematics logs  --id $WORKSPACE_ID --act-id Activity_ID

ibmcloud schematics workspace delete --id $WORKSPACE_ID
ibmcloud schematics workspace list
```
## How to use IBM Cloud Registry

Install the Container Registry plug-in if not installed.

```bash
ibmcloud plugin install -f -r "IBM Cloud" container-registry
```

Execute the following commands to create the registry namespace.

```bash
ibmcloud login -a https://cloud.ibm.com     # Login to IBM cloud account. In case of single sign on, use --sso.
ibmcloud cr region-set eu-central   # Set the registry region. For an example, Frankfort region is set here.
ibmcloud cr namespace-add iac-example-ns    #Create namespace. For an example, iac-example-ns namespace is created here.
```

Following is an example of hello-world application image deployed in `iac-example-ns` namespace in Frankfort region.

```bash
de.icr.io/iac-example-ns/hello_world_repo:1.0   # de.icr.io is the Registry URL, hello_world_repo is the repository, 1.0 is image version.
```

## Project Validation

To have access to the IKS cluster execute this **IBM Cloud CLI** command (`NAME` is the cluster name):

```bash
ibmcloud ks cluster config --cluster $NAME
```

If the project was executed with **Terraform**, get the outputs and kubectl configured executing these commands:

```bash
terraform output
ibmcloud ks cluster config --cluster $(terraform output cluster_id)
```

If the project was executed with **IBM Cloud Schematics**, get the outputs and kubectl configured executing these commands:

```bash
ibmcloud schematics workspace list          # Identify the WORKSPACE_ID
ibmcloud schematics workspace output --id $WORKSPACE_ID --json

ibmcloud ks cluster config --cluster $(ibmcloud schematics output --id $WORKSPACE_ID --json | jq -r '.[].output_values[].cluster_id.value')
```

Some `kubectl` commands to verify you have access are:

```bash
kubectl cluster-info
kubectl get nodes
kubectl get pods -A
```

Some `oc` commands to verify you have access are:

```bash
oc cluster-info
oc get nodes
oc get pods -A
```
