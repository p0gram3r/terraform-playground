provider "aws" {
  version = "~> 2.6"
  region  = "${var.AWS_REGION}"
  profile = "${var.AWS_PROFILE}"
}


data "aws_ami" "ubuntu" {
  owners      = [ "099720109477" ] # Canonical
  most_recent = true

  filter {
    name   = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*" ]
  }

  filter {
    name   = "virtualization-type"
    values = [ "hvm" ]
  }

}


resource "aws_instance" "example" {
  ami           = "${data.aws_ami.ubuntu.image_id}"
  instance_type = "t2.micro"

  vpc_security_group_ids = [ "${aws_security_group.instance.id}" ]

  user_data = <<-EOF
              #!/bin/bash
              echo "${var.SERVER_MESSAGE}" > index.html
              nohup busybox httpd -f -p "${var.SERVER_PORT}" &
              EOF

  tags = {
    Name = "${var.INSTANCE_NAME}"
  }
}


resource "aws_security_group" "instance" {
  name = "${var.INSTANCE_NAME}"

  ingress {
    from_port   = "${var.SERVER_PORT}"
    to_port     = "${var.SERVER_PORT}"
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
