variable "name" {}
variable "ami" {}
variable "instance_type" {}
variable "key_name" {
    sensitive = true
}
variable "domain-name" {}
variable "serverhostname" {}
variable "DOCKER_LOGIN_ACCESS_TOKEN" {
    sensitive = true
}
variable "DOCKER_LOGIN_USERNAME" {
    sensitive = true
}