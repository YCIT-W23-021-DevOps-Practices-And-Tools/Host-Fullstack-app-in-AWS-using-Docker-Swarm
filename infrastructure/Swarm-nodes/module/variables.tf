variable "name" {}
variable "ami" {}
variable "instance_type" {}
variable "key_name" {
    sensitive = true
}

variable "domain-name" {
    sensitive   = true
}
