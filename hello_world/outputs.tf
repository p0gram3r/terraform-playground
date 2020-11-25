output "hello-world-service-URL" {
  value = "${aws_instance.example.public_ip}:${var.SERVER_PORT}"
}