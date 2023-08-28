variable "vpc_name" {
    type = string
    default = "vpc-1"
}
variable "cidr" {
    type = string
}
variable "azs" {
    type = list(string)
}

variable "name_region" {
  type = string
  default = "us-east-1"
}

variable "instance_name1" {
  type = string
  default = "instance_1"
}

variable "instance_name2" {
  type = string
  default = "instance_2"
}