variable "AWS_REGION" {
  description = "AWS region to create the instances in"
  default     = "eu-central-1"
}


variable "AWS_PROFILE" {
  description = "Name of the AWS profile"
  default     = ""
}


variable "SERVER_PORT" {
  description = "The HTTP listener port of the server"
  default     = 8080
}


variable "SERVER_MESSAGE" {
  description = "The message the server will respond with"
  default     = "Hello World!"
}


variable "INSTANCE_NAME" {
  description = "Name of the EC2 instance"
  default     = "tf-playground-hello-world"
}