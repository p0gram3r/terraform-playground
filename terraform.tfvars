terragrunt = {
  remote_state {
    backend = "s3"

    config = {
      encrypt = true
      bucket = "remote-state-terraform-playground"
      key = "${path_relative_to_include()}/terraform.tfstate"
      region = "eu-central-1"
      profile = "p0g"
    }
  }

}

