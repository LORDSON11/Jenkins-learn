provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh"
  description = "Allow SSH"
  vpc_id      = data.aws_vpc.default.id

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

resource "aws_instance" "web" {
  ami                    = "ami-0c768662cc797cd75" # ✅ Ubuntu 22.04 LTS in ap-south-1
  instance_type          = "t2.micro"
  key_name               = "node" # ✅ Must match AWS key-pair name
  security_groups        = [aws_security_group.allow_ssh.name]
  associate_public_ip_address = true

  tags = {
    Name = "ci-demo"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = var.private_key
      host        = self.public_ip
    }
  }
}

