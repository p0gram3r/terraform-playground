terragrunt = {
  remote_state {
    backend = "s3"

    config {
      encrypt = true
      bucket = "p0g-terraform-remote-state-storage"
      key = "${path_relative_to_include()}terraform.tfstate"
      region = "eu-central-1"
      profile = "p0g"
    }
  }

  terraform {
  
  }
}

