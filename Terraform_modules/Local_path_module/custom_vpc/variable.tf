variable "AWS_ACCESS_KEY" {
  type    = string
  default = ""
}

variable "AWS_REGION" {
  type    = string
  default = "us-east-2"
}

variable "vpcname" {
  description = "Name to be used on all the resources as identifier"
  type    = string
  default = ""
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type    = string
  default = "0.0.0.0/0"
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type    = string
  default = "default"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type    = bool
  default = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type    = bool
  default = true
}

variable "enable_ipv6" {
  description = "Request an Amazon provided IPv6 CIDR block with a /56 prefix length for the VPC"
  type    = bool
  default = false
}

variable "vpcenvironment" {
  description = "AWS VPC Environment Name"
  type    = string
  default = "Development"
}