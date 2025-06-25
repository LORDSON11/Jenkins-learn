provider "aws" {
  region = "ap-south-1"
}

variable "private_key_path" {
  description = "Path to the SSH private key"
  default     = "/home/lordson/Downloads/node.pem"
  sensitive   = true
}

resource "aws_key_pair" "deployer" {
  key_name   = "node"
  public_key = file("${path.module}/id_rsa.pub")  # Ensure this file exists
}

resource "aws_instance" "web" {
  ami                    = "ami-0c768662cc797cd75"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  provisioner "remote-exec" {
    inline = [
      "sudo apt update"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  tags = {
    Name = "DockerApp"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh"
  description = "Allow SSH & HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
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
