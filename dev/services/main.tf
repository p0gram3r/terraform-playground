provider "aws" {
  version = "~> 2.3"
  region = "eu-central-1"
  profile = "p0g"
}


variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}


resource "aws_instance" "example" {
  ami = "ami-0f0debf49705e047c"
  instance_type = "t2.micro"

  tags {
    Name = "terraform-example"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
}


resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}