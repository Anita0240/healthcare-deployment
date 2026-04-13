provider "aws" {
  region = "ap-south-1" # Mumbai Region
}

# 1. Security Group (Firewall setup)
resource "aws_security_group" "django_sg" {
  name        = "django-sg"
  description = "Allow SSH and HTTP for Django"

  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Django port
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules (Internet access for VM)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. EC2 Instance (Virtual Machine)
resource "aws_instance" "django_server" {
  ami           = "ami-0dee22c13ea7a9a67" # Ubuntu 22.04 LTS in Mumbai
  instance_type = "t3.micro"             # Free tier eligible
  
  # Security group attach karna
  vpc_security_group_ids = [aws_security_group.django_sg.id]

  tags = {
    Name = "DjangoServer-Terraform"
  }
}

# 3. Output IP 
output "instance_public_ip" {
  value = aws_instance.django_server.public_ip
}