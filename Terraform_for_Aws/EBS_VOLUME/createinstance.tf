resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name
  
  

  tags = {
    Name = "custom_instance"
  }

}

#EBS resource creation

  resource "aws_ebs_volume" "ebs-volume-1" {
    availability_zone = "us-east-2a"
    size              = 50
    type              = "gp2"
    tags = {
      Name = "Secondary Volume Disk"
    }
  }

resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.ebs-volume-1.id
  instance_id = aws_instance.MyFirstInstnace.id
}
