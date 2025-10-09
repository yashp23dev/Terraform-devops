module "ec2_cluster" {
    source = ""

    name = "my-ec2-cluster"
    ami  = "ami-0f40c8f97004632f9"  # Replace with a valid AMI ID
    instance_type = "t2.micro"
    subnet_id = "subnet-e92f9cc8"  

    tags = {
        Terraform = "true"
        Environment = "dev"
    }
}