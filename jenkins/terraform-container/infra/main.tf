provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c768662cc797cd75"
  instance_type = "t2.micro"
  key_name      = "node"
  
  tags = {
    Name = "Jenkins-Deploy-Instance"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
