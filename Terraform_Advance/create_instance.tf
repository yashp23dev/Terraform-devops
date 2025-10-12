provider "aws" {
  region = var.AWS_REGION
}

module "ec2_cluster" {
    source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance.git"

    name = "my-ec2-cluster"
    ami  = "ami-0f40c8f97004632f9"  # Replace with a valid AMI ID
    instance_type = "t2.micro"
    subnet_id = "subnet-e92f9cc8"  
    instance_count = var.environment == "production" ? 2 : 1

    tags = {
        Terraform = "true"
        Environment = var.environment
    }
}