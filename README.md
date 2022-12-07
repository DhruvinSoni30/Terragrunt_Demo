# What is Terragrunt?
Terraform is an open-source infrastructure as a code (IAC) tool that allows to create, manage & deploy the production-ready environment. While using terraform it is very important to bring a level of quality standards to your code. One of these standards is Don’t Repeat Yourself (DRY) which is introduced by Terragrunt and means not to repeat any part of your code as long as you can type it once, then refer to it from any part of your code.

𝐓𝐞𝐫𝐫𝐚𝐠𝐫𝐮𝐧𝐭 is an additional wrapper that is built on top of the Terraform. Terraform is a great Infrastructure as Code tool to manage your infrastructure but as the project size grows and when you have multiple environments (Development, Testing, Staging, Production, etc..) at that time t𝐞𝐫𝐫𝐚𝐠𝐫𝐮𝐧𝐭 will be most useful tool.

# Challenges with Terraform:
If you need to manage multiple environments (Development, Testing, Staging, and Production etc..) infrastructure with Terraform then here are the challenges you might face with Terraform -

Redundancy of code:- You need to maintain multiple copies of the same code for each of the environment.
Manual update of code:- If there are the same variables that are being used for all the environments then you have to remember and manually update each variable.

# Why to use Terragrunt?

* Keep your backend configuration DRY
* Keep your Terraform CLI arguments DRY
* Execute Terraform commands on multiple modules at once
* Execute custom code before or after running Terraform.
* Work with multiple cloud accounts
* Terragrunt not only helps you with managing your terraform workspaces effectively but it can also help you with multiple Terraform modules, managing Terraform remote state, etc.

This article is a beginner’s level guide for those who want to learn Terragrunt and in this article, I will create an ec2 instance in prod, dev & stg environment!

# Installation:
To install Terragrunt we need to install Terraform first

# Terragrunt implementation using the ec2-instance module:

But before we proceed further there are few points which you should know about Terragrunt :-
* Terragrunt never recommends duplication of code.
* Terragrunt heavily relies on terraform modules, so that we can keep our code DRY without polluting with the duplicate code.

# What are Terraform modules:

Terraform is an IAC(infrastructure as Code) framework for managing and provisioning the infrastructure but have you ever thought of creating only a single terraform configuration file for managing the complete cloud infrastructure?

Well yes that's possible that is why terraform introduced a concept of modules which will help you to organise your terraform configuration so that you can re-use the it and keep your terraform code more clean and modular.

# Some Prerequisites:
* Terraform modules
* terragrunt.hcl file for writing your Terragrunt configuration.
* Some common commands:
  ```
  terragrunt validate (To validate the config file)
  terragrunt init (To initialize the working directory)
  terragrunt plan (To get the execution plan)
  terragrunt apply (To spin up the resources)
  terragrunt destroy (To destroy the resources)
  ```
# Create the AWS EC2 module
* In order to make the code much cleaner, I have created the AWS EC2 module, you can download the module from here, and take a look at code at here
* The module consists of 3 files. `main.tf`, `variables.tf` & `outputs.tf`
* The `main.tf` file contains the code for spinning up the EC2 instance

  ```
  resource "aws_instance" "demo_instance" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    availability_zone      = var.availability_zone
    tags = {
      Name = "${var.tags}"
    }
  }
  ```

* To use this code with Terragrunt, you need to turn this code into a module that can be configured differently in different environments. To do that, add input variables for any values that differ between environments i.e. `variables.tf` file

  ```
  # AMI ID
  variable "ami_id" {
    type = string
  }

  # Instance Type
  variable "instance_type" {
    type = string
    default = "t2.micro"
  }

  # AZ
  variable "availability_zone" {
    type = string
  }

  # Tags
  variable "tags" {
    type = string
    default = "my_instance"
  }
  ```

* The `output.tf` file contains the code for getting EC2 instance's public IP

  ```
  output "public_IP" {
    value = aws_instance.demo_instance.public_ip
  }
  ```

# Create Terragrunt.hcl files

* Now you're ready to deploy your ec2-instance module across multiple l environments: i.e. prod, dev & stg.
* The idea behind Terragrunt is that you define your environments using terragrunt.hcl files that specify what modules to deploy and what inputs to pass to those modules.
* Now, create a folder like terragrunt_project/dev , terragrunt_project/lve & terragrunt_project/prod in your machine

  ```
  VW3N7VQKQX:terragrunt_project dhruvins$ ls -la
  total 8
  drwxr-xr-x    6 dhruvins  staff   192 Dec  7 02:02 .
  drwx------@ 146 dhruvins  staff  4672 Dec  7 01:27 ..
  drwxr-xr-x@   5 dhruvins  staff   160 Dec  7 01:58 dev
  drwxr-xr-x@   5 dhruvins  staff   160 Dec  7 02:09 prod
  drwxr-xr-x@   5 dhruvins  staff   160 Dec  7 02:12 stg
  VW3N7VQKQX:terragrunt_project dhruvins$
  ```

* Now, add `terragrunt.hcl` file in each directory

  ```
  VW3N7VQKQX:terragrunt_project dhruvins$ ls -la dev/
  total 16
  drwxr-xr-x@ 5 dhruvins  staff   160 Dec  7 01:58 .
  drwxr-xr-x  6 dhruvins  staff   192 Dec  7 02:02 ..
  -rw-r--r--  1 dhruvins  staff   528 Dec  7 01:58 terragrunt.hcl
  VW3N7VQKQX:terragrunt_project dhruvins$

  VW3N7VQKQX:terragrunt_project dhruvins$ ls -la prod/
  total 16
  drwxr-xr-x@ 5 dhruvins  staff   160 Dec  7 02:09 .
  drwxr-xr-x  6 dhruvins  staff   192 Dec  7 02:02 ..
  -rw-r--r--  1 dhruvins  staff   529 Dec  7 01:59 terragrunt.hcl
  VW3N7VQKQX:terragrunt_project dhruvins$

  VW3N7VQKQX:terragrunt_project dhruvins$ ls -la stg/
  total 16
  drwxr-xr-x@ 5 dhruvins  staff   160 Dec  7 02:12 .
  drwxr-xr-x  6 dhruvins  staff   192 Dec  7 02:02 ..
  -rw-r--r--  1 dhruvins  staff   528 Dec  7 01:58 terragrunt.hcl
  VW3N7VQKQX:terragrunt_project dhruvins$
  ```

  ```
  VW3N7VQKQX:terragrunt_project dhruvins$ tree
  .
  ├── dev
  │   └── terragrunt.hcl
  ├── prod
  │   └── terragrunt.hcl
  ├── stg
  │   └── terragrunt.hcl

  3 directories, 3 files
  VW3N7VQKQX:terragrunt_project dhruvins$
  ```

* Now, we need to use the EC2 module for each environment, add below line in `terragrung.hcl` file of all the environment

  ```
  terraform {
  source  = "tfr:///DhruvinSoni30/ec2-instance/aws?version=1.0.1"
  }
  ```

* The above code will fetch the code for creating EC2 instance from terraform registry

* Now, we need to add the provider configuration in terraform.hcl file

  ```
  generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
    provider "aws" {
      profile = "default"
      region  = "ap-south-1"
  }
  EOF
  }
  ```

* The provider can be optional and it can be avoided if the provider.tfconfiguration already exists inside all the environments
* The above provider configuration will overwrite any existing local provider configuration
* Next, we need to define the inputsconfiguration for all the environments because for each Terragrunt implementation we need to provide some mandatory inputs required in EC2 module.
* Add below code in terragrunt_project/dev/terragrunt.hcl file

  ```
  inputs = {
    ami_id = "ami-074dc0a6f6c764218"
    availability_zone = "ap-south-1a"
    instance_type = "t2.micro"
    tags =  "my_ec2_instance_dev"
  }
  ```

* Add below code in `terragrunt_project/stg/terragrunt.hcl` file

  ```
  inputs = {
    ami_id = "ami-074dc0a6f6c764218"
    availability_zone = "ap-south-1a"
    instance_type = "t2.micro"
    tags =  "my_ec2_instance_stg"
  }
  ```
  
* Add below code in terragrunt_project/prod/terragrunt.hcl file

  ```
  inputs = {
    ami_id = "ami-074dc0a6f6c764218"
    availability_zone = "ap-south-1a"
    instance_type = "t2.micro"
    tags =  "my_ec2_instance_prod"
  }
  ```

Note: If you have observed correctly, then we have only changed the value of tags in all inpus

* The final terragrunt.hcl file will looks like this

  ```
  terraform {
  source  = "tfr:///DhruvinSoni30/ec2-instance/aws?version=1.0.1"
  }

  generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
    provider "aws" {
      profile = "default"
      region  = "ap-south-1"
  }
  EOF 
  }

  inputs = {
    ami_id = "ami-074dc0a6f6c764218"
    availability_zone = "ap-south-1a"
    instance_type = "t2.micro"
    tags =  "my_ec2_instance_dev"
  }
  ```

Note: Here I am taking the example of terragrunt_project/stg/terragrunt.hcl file

Run Terragrunt commands:

* terragrunt init
  The first command you need to run is terragrut init
  
* terragrunt plan
  The above command will give you the execution plan
  
* terragrunt apply
  The above command will create resources on AWS
  
* terragrunt validate
  You can validate the code using above command
  
You can verify 3 up & running EC2 instances on your AWS account!
 

# Use different backend in each environment

* Terragrunt offers a way to configure the backend for all your Terraform modules in a standardized, centralized way that minimizes code duplication. Create a new terragrunt.hcl file at the root of your terragrunt_projecttfolder, so your file layout should look like this:

  ```
  VW3N7VQKQX:terragrunt_project dhruvins$ tree
  .
  ├── dev
  │   └── terragrunt.hcl
  ├── prod
  │   └── terragrunt.hcl
  ├── stg
  │   └── terragrunt.hcl
  └── terragrunt.hcl

  3 directories, 4 files
  VW3N7VQKQX:terragrunt_project dhruvins$
  ```

* Now, add below code in the terragrunt_project/dev/terragrunt.hcl , terragrunt_project/stg/terragrunt.hcl & terragrunt_project/prod/terragrunt.hcl so that Terragrunt can automatically find the root terragrunt.hclfile and inherit its configuration

  ```
  include {
    path = find_in_parent_folders()
  }
  ```

* Now add below code in the rool terragrunt.hcl file

  ```
  # Configure S3 as a backend
  remote_state {
    backend = "s3"
    config = {
      bucket = "demo-bucket-${get_aws_account_id()}"
      region = "ap-south-1"
      key    = "${path_relative_to_include()}/terraform.tfstate"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  }
  ```

* The above code will configure S3 as the remote backend and will create demo-bucket-<account-ID> bucket in S3
get_aws_account_id() is a built in terragrunt function to get the account ID of AWS account
* path_relative_to_include() is also a build in terragrung function, it returns the relative path between the current terragrunt.hcl and other terragrunt.hcl file
* Now run terragtunt init from any of the environment it will ask your permission to create S3 bucket

* After that you can see S3 bucket like this

* S3 bucket will have 3 folder of 3 environments

* Each folder will contain state file for their environment

#Advantages of Terragrunt:

* Configure environments differently by setting different inputs in different terragrunt.hcl file
* Configure separate backends for each environment to isolate environments
* Configure backends for multiple modules and environments with no code duplication
* You can use different versions in each environment

  ```
  terraform {
    source = "<YOUR_GITHUB_URL>//ec2-instance?ref=v1.0.0"
  }
  ```
  
* Now, Let's say you have pushed the code of module in GitHub repository with tag 1.0.0 so, now you can use that as below.

  ```
  terraform {
    source = "<YOUR_GITHUB_URL>//ec2-instance?ref=v1.0.1"
  }
  ```

* Meanwhile stg & dev environment will use code of 1.0.0 release and prod will run on 1.0.1 release
* Terragrunt also allows you to run different versions of Terraform and Terraform providers in different environments by using the generate block. For example, you can generate the required_providers and required_version settings, and set them to different versions in different environments. This allows you to carefully upgrade versions across your code, one environment or even one module at a time
8 Now, let's destroy our resources with terragrunt destroy command

# Conclusion:
* Wrapping your Terraform with Terragrunt is very powerful to control and maintain the remote state with DRY concept.
