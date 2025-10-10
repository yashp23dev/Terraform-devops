module "dev_qa_vpc" {
  source             = "../../custom_vpc"

  vpcname            = "dev02-qa-vpc"
  cidr               = "10.0.1.0/24"
  enable_dns_support = "true"
  enable_ipv6        = "false"
  vpcenvironment     = "Development-Engineering-QA"
  AWS_REGION         = "us-east-1"
}