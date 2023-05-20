
# Create an EC2 instance in the public subnet
resource "aws_instance" "public_instance" {
  ami           = var.ami  # Replace with your desired AMI ID
  instance_type = "t2.micro"  # Replace with your desired instance type
  subnet_id     = aws_subnet.public.id
  #vpc_security_group_ids = aws_security_group.public_sg.id

   depends_on = [
      aws_security_group.public_sg
    ]

  tags = {
    Name = "Public Instance"
  }
}

# Create an EC2 instance in the private subnet
resource "aws_instance" "private_instance" {
  ami           = var.ami  # Replace with your desired AMI ID
  instance_type = "t2.micro"  # Replace with your desired instance type
  subnet_id     = aws_subnet.private1.id
  #vpc_security_group_ids = aws_security_group.private_sg.id

  depends_on = [
      aws_security_group.private_sg
    ]

  tags = {
    Name = "Private Instance"
  }
}


# Create a security group for the public instance
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Security group for public instance"
  vpc_id      = aws_vpc.vpc_main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a security group for the private instance
resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Security group for private instance"
  vpc_id      = aws_vpc.vpc_main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add any additional ingress or egress rules as needed
}

