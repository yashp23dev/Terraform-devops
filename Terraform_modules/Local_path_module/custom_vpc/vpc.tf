#VPC
resource "aws_vpc" "custom_vpc" {

  cidr_block                        = var.cidr
  instance_tenancy                  = var.instance_tenancy
  enable_dns_support                = var.enable_dns_support
  enable_dns_hostnames              = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block  = var.enable_ipv6

  tags = {
         name = var.vpcname
         environment = var.vpcenvironment 
  }
}