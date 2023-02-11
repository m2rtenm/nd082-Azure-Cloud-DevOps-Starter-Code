# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
Firstly, create a service principal and set the environment variables.
Before building the Packer image, create a resource group in Azure. After that, specify the same resource group name in Packer image as managed_image_resource_group_name. Feel free to change also the managed_image_name and the other details related to server (OS etc).

To build Packer image, run the following command: packer build server.json

If you changed managed_image_resource_group_name and managed_image_name in Packer template, then change them also in vars.tf. The correct variables are packer_resource_group and packer_image_name. Change the default values.

Feel free to change other variables as well. Note that location, vmsize and tags variables' default value must be the same as in Packer template.

If you have done the changes in vars.tf then run the following commands:

terraform plan -out solution.plan (output the deployment plan to solution.plan)
Provide an admin user password when prompted.

terraform apply "solution.plan" (to deploy the infrastructure based on solution.plan file)
terraform destroy (to destroy and remove all the infrastructure)

### Output

The successful message after building Packer image:

Build 'azure-arm' finished after 4 minutes 19 seconds.

==> Wait completed after 4 minutes 19 seconds

==> Builds finished. The artifacts of successful builds are:
--> azure-arm: Azure.ResourceManagement.VMImage:

OSType: Linux
...

The final rows of successful message after command terraform plan -out solution.plan:

Plan: 20 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: solution.plan

To perform exactly these actions, run the following command to apply:
    terraform apply "solution.plan"

The final row of successful command terraform apply "solution.plan":
Apply complete! Resources: 20 added, 0 changed, 0 destroyed.

The final row of successful command terraform destroy:
Destroy complete! Resources: 20 destroyed.