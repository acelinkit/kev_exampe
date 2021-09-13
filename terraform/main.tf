terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

# Get latest Ubuntu image
data "aws_ami" "ami_0" {
  # https://ubuntu.com/server/docs/cloud-images/amazon-ec2
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "app_server1" {
  ami           = data.aws_ami.ami_0.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.keypair_0.id
  vpc_security_group_ids = [aws_security_group.sg_0.id]

  tags = {
    Name = "appserver1"
  }
}

resource "aws_instance" "app_server2" {
  ami           = data.aws_ami.ami_0.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.keypair_0.id
  vpc_security_group_ids = [aws_security_group.sg_0.id]

  tags = {
    Name = "appserver2"
  }
}

resource "aws_key_pair" "keypair_0" {
  key_name_prefix = "kevexample"
  public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUUAbJuabL8/LdzZv/7Nc88MbQ5nrrvc+fBkJPqttefdcfaxB0UkK4/b30+X8crjWPJJdbSlxu453w/eLQrroOj5qIUxoqNlHf8TIm6r37KoGUWUswjUyikvrU2LtNGoVjTTwLqGKSmlghyF/FI6lM070PM8+iWAarw0AJgLQQVXkByk3SO1axtkuLjmHhnV9Y3n2E1BqT1OIrZhacUJBLj/aHRrFIz0YN6K5cytk9mL7TQNFqvRqG0B1bFR/1fRr56oCFzfbOYWyg12zVsxM5kH5+4acxLHpTCH9fANYYhppuDFEY2mF7tPla54YNdBTUTA6gUNsCSwzptrEnaDdn arlan@DESKTOP-AIPQ1BB"
}

resource "aws_security_group" "sg_0" {
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    function = "generalsg"
  }
}