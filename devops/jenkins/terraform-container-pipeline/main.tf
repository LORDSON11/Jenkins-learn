provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c768662cc797cd75"
  instance_type = "t2.micro"

}