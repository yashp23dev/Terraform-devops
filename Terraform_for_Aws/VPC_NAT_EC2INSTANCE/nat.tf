# Define Ecternal Ip
resource "aws_eip" "levelup-nat" {
  #vpc = true
}

# Custom NAT Gateway for the VPC

resource "aws_nat_gateway" "levelup-nat-gw" {
  allocation_id = aws_eip.levelup-nat.id
  subnet_id     = aws_subnet.levelupvpc-public-1.id
  depends_on = [ aws_internet_gateway.levelup-gw ]

}

# Custom VPC NAT Gateway

resource "aws_route_table" "levelupvpc-private" {
  vpc_id = aws_vpc.levelupvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.levelup-nat-gw.id
  }

  tags = {
    Name = "levelupvpc-private"
  }
}

# Associate Private Subnets with the Route Table

resource "aws_route_table_association" "levelupvpc-private-1-a" {
  subnet_id      = aws_subnet.levelupvpc-private-1.id
  route_table_id = aws_route_table.levelupvpc-private.id
}

resource "aws_route_table_association" "levelupvpc-private-2-a" {
  subnet_id      = aws_subnet.levelupvpc-private-2.id
  route_table_id = aws_route_table.levelupvpc-private.id
}

resource "aws_route_table_association" "levelupvpc-private-3-a" {
  subnet_id      = aws_subnet.levelupvpc-private-3.id
  route_table_id = aws_route_table.levelupvpc-private.id
}
