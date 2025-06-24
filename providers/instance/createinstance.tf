provider "aws" {
	access_key = "access_key"
	secret_key = "secret_key"
	region = "us-east-2"
}

resource "aws_instance" "MyFirstIstance" {
	ami  = "ami-05692172625678b4e"
	instance_type = "t2.micro"
}
