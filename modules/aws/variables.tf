# EC2
variable "number_of_instances" {
  type    = number
  default = 1
}

variable "instance_type" {
  type    = string
  default = "t3a.micro"
}

variable "key_name" {
  type    = string
  default = "lambda-test-key"
}

# Network
variable "var_region" {
  type = string
  default = "us-east"
}

variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "Lambda-Test-VPC"

}
variable "private_subnet_cidr" {
  type    = string
  default = "192.168.0.0/24"
}

variable "public_subnet_cidr" {
  type    = string
  default = "192.168.1.0/24"
}

variable "public_subnet_az" {
  type    = string
  default = "us-east-1a"
}

variable "private_subnet_az" {
  type    = string
  default = "us-east-1b"
}
