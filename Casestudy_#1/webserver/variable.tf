variable "SSH_CIDR_WEB_SERVER" {
  type = string
  default = "0.0.0.0/0"
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "AMIS" {
    type = map
    default = {
        "us-east-1" = "ami-0c94855ba95c71c99"
        "us-east-2" = "ami-0b59bfac6be064b78"
        "us-west-1" = "ami-0b2f6494ff0b07a0e"
        "us-west-2" = "ami-08962a4068733a2b6"
    }
  
}

variable "AWS_REGION" {
  type = string
  default = "us-east-2"
}

variable "ENVIRONMENT" {
  type = string
  default = "Development"
}

variable "PUBLIC_KEY_PATH" {
  description = "Public Key Path"
  default = "~/.ssh/levelup_key.pub"
}