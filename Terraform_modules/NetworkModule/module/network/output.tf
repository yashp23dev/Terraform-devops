output "vpc_id" {
  value = aws_vpc.custom_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.subnet_public.id
}

output "security_group_id" {
  value = aws_security_group.custom_sg.id
}