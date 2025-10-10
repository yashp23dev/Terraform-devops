module "dev_vpc" {
  source             = "../../custom_vpc"
  
  vpcname            = "dev01-vpc"
  cidr               = "10.0.0.0/24"
  enable_dns_support = "true"
  enable_ipv6        = "true"
  vpcenvironment     = "Development-Engineering"
}