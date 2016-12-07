variable environment{}
variable "access_key" {}
variable "secret_key" {}
variable "aws_key_pair_name" {}
variable db_username{}
variable db_password{}
variable app_name{}

variable count{
  default = "2"
}

variable "region"     {
  description = "AWS region to host your network"
  default     = "us-east-1"
}

variable "aws_key_pair_path" {
  default=""
}

variable "amis" {
  default = {
    us-east-1 = "ami-07bdee6d"
  }
}

variable "user"{
  default = "steven-acreman"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr_1" {
    default = "10.0.2.0/24"
}