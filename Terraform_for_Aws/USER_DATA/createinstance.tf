resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name
  
  user_data = file("installapache.sh")

  tags = {
    Name = "custom_instance"
  }

}

output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip
}


