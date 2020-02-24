# Manage S3 bucket with Terraform

## Terraform
Terraform is an open source tool that codifies APIs into declarative configuration files that can be shared amongst team members, treated as code, edited, reviewed, and versioned. Terraform enables you to safely and predictably create, change, and improve your infrastructure.

Apart from the simplicity of Terraform, this tool can be used with different providers making it the best choice when working with different service. It also embraces the separation of concern (modularity), which makes it easy to break down the infrastructure into small components that can be re-used and easily maintained. You can find more details on Terraform on the official website.

## What we will be building
 We will be building a simple S3 bucket infrastructure as a demonstration. Below are the services we will be provisioning.

  - Create four S3 buckets(staging, staging-logs, production, production-logs).
  - Link stage bucket to stage-logs and production bucket to production-logs to enable automatic server access logging.
  - Enable versioning.
  - Create IAM user, IAM policy, bucket ploicy and assign to relavant bucket(prod or stage).
    
## Terraform Installation
  [Install Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

## Setting up the project
At this point, you should have a Heroku account set up, and terraform binaries installed on your machine. To confirm that terraform has been correctly installed, run terraform version from the command line. You should get a response similar to the one below.
```
C:\terraform>terraform version
Terraform v0.12.2
```
The version may be different from mine depending on what version you have installed, nevertheless, the functionality will still be the same. Run the command below to create a working directory and initial terraform files.

### Set environment variables
For local setup we are using `terraform.tfvars` to configure environment variables.
Please make a copy of `terraform.tfvars.sample` as `terraform.tfvars`. Then you might need to set some variables.

## Plan (Test) Changes
So far we have been writing code but we have not even tested if they work or not. Through terraform plan we can dry run our scripts against the provider and check if your scripts are okay. Lets to that

![alt text](https://cdn-images-1.medium.com/max/1600/1*mc6GrUwoFoYMe8bxD8iGSA.png)

The terraform init command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.

When we run terraform plan, terraform will dry run your configuration against the provider API and verify whether what you have specified is possible. If what we declared is not possible you might get errors, which might range from the wrong resource to unique names such as Heroku apps.

Terraform plan also notifies us of how many resources will be created, updated or destroyed.

## Applying Changes
Once we are content with the changes, we can run terraform apply. This command will run the configuration against the provider and provision the resources for us.
![alt text](https://cdn-images-1.medium.com/max/1400/1*wE8_7fTdve5xZm8yteDgQg.png)
When terraform is applying your changes, it will report in real-time the progress of each resource declared. And once complete it also provides a report of resources created, changed, or destroyed.

Once the command has completed executing, visit your AWS  dashboard, new S3 bukets and IAM user  should be created there.



## Destroy Applied changes
In one way or the other, you might want to delete your infrastructure. Terraform provides you will a command terraform destroy. This command will nuke all the resources that were created by terraform apply command

![alt text](https://cdn-images-1.medium.com/max/800/1*GOHWpRkiH1A8OjuV-p4tMw.png)


## Author
  [Jaspinder Pawar](https://github.com/JaspinderPawar)
