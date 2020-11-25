data "external" "helper-crypto" {
  program = [
    "bash",
    "${path.module}/helper/generate_crypto.sh"
  ]
}

locals {
  kube_token    = data.external.helper-crypto.result.token
  kube_cert_key = data.external.helper-crypto.result.certificate_key
}

output "kube_token" {
  value = local.kube_token
}
output "kube_cert_key" {
  value = local.kube_cert_key
}
