variable "AWS_REGION" {
  description = "AWS Region"
  default     = "eu-central-1"
}

variable "AWS_SHARED_CREDENTIALS_FILE" {
  description = "Path to AWS shared credentials file"
  default     = "~/.aws/credentials"
}

variable "AWS_PROFILE" {
  description = "Name of the AWS profile"
  default     = "platform-team"
}

variable "APP_COLOR_BLUE" {
  default = "blue"
}

variable "APP_COLOR_GREEN" {
  default = "green"
}
