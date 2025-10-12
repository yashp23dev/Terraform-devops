#Variables

variable "AWS_REGION" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "The environment to deploy resources in"
  type        = string
  default     = "dev"
}
