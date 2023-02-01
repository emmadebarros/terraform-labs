# Configure the AWS Provider
#Hard-coded access and secret keys are not recommended
provider "aws" {
  region = "us-east-1"
  access_key = "AKIAXIEQIBENQDZTYEIM"
  secret_key = "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"
}

/*
Basic structure of how to create a resource within a provider

resource "<provider>_<resource_type>" "<name>" {
  #config options...
  key = "<value>"
  key = "<value>"
  #etc.
}

AWS is not aware of the <name>, it is only to refer to it through the terraform plan

example: Create a VPC

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
*/

#provision an EC2 instance of Ubuntu
#uncommment this section to try out
resource "aws_instance" "my-first-server" {
  ami           = "ami-00874d747dde814fa"
  instance_type = "t2.micro"
  tags = {
    Name = "test-pour-mimi"
  }
}

#provision a VPC instance
#uncommment this section to try out
/*
resource "aws_vpc" "vpc-1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "prod-vpc"
  }
}
*/

#provision a SUBNET instance
#uncommment this section to try out
/*
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-subnet"
  }
}
*/

/*
NOTES
======

https://youtu.be/SLB_c_ayRMo
https://developer.hashicorp.com/terraform/intro

1- If a change is made to a resource in this file, e.g. add a "name" tag, Terraform will UPDATE the infra to match the state DECLARED in this file. It will not spin up another instance with a name tag. This is because it's a DECLARATIVE language, with means the terraform engine doens't read line by line as a set of executable instructions. Instead, it compares the current state of the infra with this file and applies the appropriate changes. However, it still follows the concept of immutable infrastructure.

2- Terraform destroy will destroy (by default) the whole infra declared in the file. If you only want to delete certain resources, you need to pass in extra parameters to the command.

3- Because it's a declarative language, commenting out a block essentially performs the same action as the "terraform destroy" command; Terraform will compare the current state with new state in the file and applies the changes accordingly; it says "hey, according the what's declared in here, we should not have nay resources spun up, so let's rectify the situation".
So, you can use that as a tool to delete instances/resources in any cloud provider. As long as you just comment/delete it from your terraform file, terraform is going to figure out what you want and what you don't want.

4- Usually, pretty  much everything you can do through your cloud provider's GUI or console, you can do in terraform.

5- Terraform is intelligent enough to figure out the order in which the resources need to be provisoned (dependency order) in order for the infra to be built properly. Example, it knows a subnet belongs inside a VPC so even if the subnet resource is declared before the vpc resource, everything will be created properly in the background.

!! There are instances where it can't figure out the ordering on its own, but if you look at the documentation, it will always tell you whenever terraform can't do it and it will give you a workaround, for example passing in an extra flag, etc.

6- If you're sure about your apply action, you can type "terraform apply --auto-approve"

7- "terraform state list "terraform state show <resource_name>" --> this will give you info that will normally only be stored/visbile on the aws console

8- "terraform refresh" refreshes the state without redeploying and make changes to the configurations (in case in prod environment) (example use case of using the refresh command is when adding output values to terarform plan)

9- "terraform destroy/apply -target <resource>", this destroys/creates individual resources without changing the plan.

10- Other common config files that can be created within the directory are:

> fileName = main.tf
> purpose = main config file containing resource difnitions

> fileName = variables.tf
> purpose = contains variable declarations

> fileName = output.tf
> purpose = contains output declarations from resources

> fileName = provider.tf
> purpose = contains provider definitions

11- Values that are written within the main.tf configuration file are considered to be hard-coded values. Hard-coded values are not a good idea because it limits the reusability of the code (which defeats the purpose of using Iac). We want to make sure that the same code can be used again and again to deploy resource based on a set of input variables that can be provided during the execution.

12- basic variable types within terraform are: string, number (+/-), bool, any
Since the type is optional, the default is any
Additional types are: list, map, object, tuple
*/