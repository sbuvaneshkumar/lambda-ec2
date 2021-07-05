output "bastion_host" {
  value = aws_instance.bastion-lambdatest-ec2.public_dns
}

output "host" {
  value = [aws_instance.lambdatest-ec2.*.private_dns]
}

output "pem_key" {
  value       = "./key.pem"
  description = "The PEM Key can be found in the current directory"
}
