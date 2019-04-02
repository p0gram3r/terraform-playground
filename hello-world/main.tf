provider "aws" {
  version = "~> 2.3"
  region = "eu-central-1"
  profile = "p0g"
}


terraform {
  backend "s3" {}
}


resource "aws_instance" "example" {
  ami = "ami-0405a63f383fddd6b"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    "${aws_security_group.instance.id}"
  ]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF


  tags {
    Name = "terraform-example"
  }
}


resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
