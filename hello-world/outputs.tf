output "worker_node_public_ip" {
  value = "${aws_instance.example.public_ip}"
}