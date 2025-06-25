provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  tags = {
    Name = "web-sg"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0c768662cc797cd75"  # Amazon Linux 2 in ap-south-1
  instance_type          = "t2.micro"
  key_name               = "node"  # ✅ just the key pair name, not .pem
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "ci-cd-instance"
  }
}
