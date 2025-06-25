provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP and SSH"
  vpc_id      = data.aws_vpc.default.id

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
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "docker_ec2" {
  ami           = "ami-0c768662cc797cd75"
  instance_type = "t2.micro"
  key_name      = "node"
  security_groups = [aws_security_group.allow_http.name]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nginx
              echo "<h1>Hello from Lordson's Jenkins + Terraform EC2</h1>" > /var/www/html/index.html
              systemctl start nginx
              systemctl enable nginx
            EOF

  tags = {
    Name = "DockerEC2"
  }
}
