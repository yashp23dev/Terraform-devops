variable "aws_region" {
  default = "us-east-2"
}

variable "environment_tag" {
  default     = "Production"
  description = "Environment tag"
}

variable "public_key_path" {
  description = "Path to the public key"
  default     = "~/.ssh/custom_key.pub"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0c55b159cbfafe1f0" # use latest ami id for the region
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
}