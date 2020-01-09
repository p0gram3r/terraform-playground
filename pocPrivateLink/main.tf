provider "aws" {
  version                 = "~> 2.3"
  region                  = "${var.AWS_REGION}"
  shared_credentials_file = "${var.AWS_SHARED_CREDENTIALS_FILE}"
  profile                 = "${var.AWS_PROFILE}"
}


terraform {
  backend "s3" {}
  required_version = ">= 0.8.7"
}


data "aws_availability_zones" "all" {}


module "web-service-blue" {
  source = "..\/..\/..\/modules\/echoheaders"

  APP_COLOR        = "${var.APP_COLOR_BLUE}"
  CIDR_VPC         = "10.100.0.0/16"
  CIDR_SUBNET_LIST = [ "10.100.1.0/24", "10.100.2.0/24" ]
}


module "web-service-green" {
  source = "..\/..\/..\/modules\/echoheaders"

  APP_COLOR        = "${var.APP_COLOR_GREEN}"
  CIDR_VPC         = "10.200.0.0/16"
  CIDR_SUBNET_LIST = [ "10.200.1.0/24", "10.200.2.0/24", "10.200.3.0/24" ]
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.60.0"

  name = "DMZ"
  cidr = "10.0.0.0/16"

  azs = [ "${data.aws_availability_zones.all.names}" ]

  public_subnets = [ "10.0.1.0/24", "10.0.2.0/24" ]
}


###
# Privatelink
###

module "secgroup-privatelink" {
  source  = "github.com/terraform-aws-modules/terraform-aws-security-group//modules/http-80"
  version = "2.16.0"

  vpc_id = "${module.vpc.vpc_id}"
  name   = "privatelink"

  ingress_cidr_blocks = [ "${module.vpc.vpc_cidr_block}" ]

  auto_egress_rules      = [ ]
  auto_ingress_with_self = [ ]
}


module "privatelink-blue" {
  source = "../../../modules/privatelink"

  consumer_vpc_id             = "${module.vpc.vpc_id}"
  consumer_subnet_ids         = [ "${module.vpc.public_subnets}" ]
  consumer_security_group_ids = [ "${module.secgroup-privatelink.this_security_group_id}" ]
  provider_nlb_arns           = [ "${module.web-service-blue.nlb_arn}" ]
}
module "privatelink-green" {
  source = "../../../modules/privatelink"

  consumer_vpc_id             = "${module.vpc.vpc_id}"
  consumer_subnet_ids         = [ "${module.vpc.public_subnets}" ]
  consumer_security_group_ids = [ "${module.secgroup-privatelink.this_security_group_id}" ]
  provider_nlb_arns           = [ "${module.web-service-green.nlb_arn}" ]
}


data "aws_network_interface" "netif_blue" {
  count = 2
  id    = "${element(module.privatelink-blue.consumer_eni_ids, count.index)}"
}
data "aws_network_interface" "netif_green" {
  count = 2
  id    = "${element(module.privatelink-green.consumer_eni_ids, count.index)}"
}

###
# Load Balancer
###

module "secgroup-alb" {
  source  = "github.com/terraform-aws-modules/terraform-aws-security-group//modules/http-80"
  version = "2.16.0"

  vpc_id = "${module.vpc.vpc_id}"
  name   = "alb"

  ingress_cidr_blocks    = [ "0.0.0.0/0" ]
  auto_ingress_with_self = [ ]
}


resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ "${module.secgroup-alb.this_security_group_id}" ]
  subnets            = [ "${module.vpc.public_subnets}" ]
}


resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "color blind ? ;)"
      status_code  = "404"
    }
  }
}


resource "aws_lb_target_group" "alb-tg-blue" {
  name        = "alb-tg-blue"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${module.vpc.vpc_id}"
}
resource "aws_lb_target_group" "alb-tg-green" {
  name        = "alb-tg-green"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${module.vpc.vpc_id}"
}


resource "aws_lb_listener_rule" "alb-listener-rule-forward-blue" {
  listener_arn = "${aws_lb_listener.alb_listener.arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.alb-tg-blue.arn}"
  }

  condition {
    field  = "path-pattern"
    values = [ "/${var.APP_COLOR_BLUE}/*" ]
  }
}
resource "aws_lb_listener_rule" "alb-listener-rule-forward-green" {
  listener_arn = "${aws_lb_listener.alb_listener.arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.alb-tg-green.arn}"
  }

  condition {
    field  = "path-pattern"
    values = [ "/${var.APP_COLOR_GREEN}/*" ]
  }
}


resource "aws_lb_target_group_attachment" "alb-tg-a-blue" {
  count = 2

  target_group_arn = "${aws_lb_target_group.alb-tg-blue.arn}"
  target_id        = "${element(data.aws_network_interface.netif_blue.*.private_ip, count.index)}"
  port             = 80
}
resource "aws_lb_target_group_attachment" "alb-tg-a-green" {
  count = 2

  target_group_arn = "${aws_lb_target_group.alb-tg-green.arn}"
  target_id        = "${element(data.aws_network_interface.netif_green.*.private_ip, count.index)}"
  port             = 80
}
