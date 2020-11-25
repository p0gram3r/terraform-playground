output "try_the_app" {
  value = [
    "http://${aws_lb.alb.dns_name}/",
    "http://${aws_lb.alb.dns_name}/${var.APP_COLOR_BLUE}/",
    "http://${aws_lb.alb.dns_name}/${var.APP_COLOR_GREEN}/"
  ]
}
