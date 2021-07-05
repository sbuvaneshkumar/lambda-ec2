output "bastion_host" {
  value = module.aws.bastion_host
}

output "host" {
  value = module.aws.host
}

output "PEM_key" {
  value       = "./key.pem"
  description = "The PEM Key can be found in the current directory"
}
