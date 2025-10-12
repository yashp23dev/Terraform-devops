variable "aws_region" {
  default = "us-east-2"
}

variable "environment_tag" {
  default     = "Production"
  description = "Environment tag"
}

variable "public_key_path" {
  description = "Path to the public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0c55b159cbfafe1f0" # use latest ami id hor the region 
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
}