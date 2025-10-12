#Provider
provider "aws" {
  region = var.aws_region
}

#Module
module "myvpc" {
    source = "./module/network"
}

#Resource key pair
resource "aws_key_pair" "custom_key" {
    key_name   = "custom_key"
    public_key = file(var.public_key_path)
}

#EC2 Instance
resource "aws_instance" "custom_ec2" {
    ami                         = var.ami_id
    instance_type               = var.instance_type
    subnet_id                   = module.myvpc.public_subnet_id
    vpc_security_group_ids      = [module.myvpc.security_group_id]
    key_name                    = aws_key_pair.custom_key.key_name

    tags = {
      Environment = var.environment_tag
    }

}