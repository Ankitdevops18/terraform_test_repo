# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "vpc_main" {
  cidr_block = "120.0.0.0/16"
  tags = {
    "Name" = var.VPC
  }
} 
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = "120.0.1.0/24"

    tags = {
      "Name" = var.pubSubnet
    }
}
resource "aws_subnet" "private1" {
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = "120.0.2.0/24"

    tags = {
      "Name" = var.pvtSubnet1
    }
}

resource "aws_subnet" "private2" {
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = "120.0.3.0/24"

    tags = {
      "Name" = var.pvtSubnet2
    }
}
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.vpc_main.id
    tags = {
      "Name" = var.IGW
    }
  
}
resource "aws_eip" "nat_eip" {
    vpc = true
    depends_on = [
      aws_internet_gateway.IGW
    ]
    tags = {
      "Name" = var.NATEIP
    } 
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public.id

    tags = {
      "Name" = var.NAT
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc_main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW.id
    }
    tags ={
        Name="Public Route Table"
    }
}

resource "aws_route_table_association" "public" {
subnet_id = aws_subnet.public.id
route_table_id = aws_route_table.public.id
}



resource "aws_route_table" "private" {
    vpc_id = aws_vpc.vpc_main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat.id
    }
    tags ={
        Name="Private Route Table"
    }
}

resource "aws_route_table_association" "private" {
subnet_id = aws_subnet.private1.id
route_table_id = aws_route_table.private.id
}

