variable "ami" {}
variable "key_name" {
    sensitive = true
}

variable "domain-name" {
    sensitive   = true
}