variable "name" {}
variable "ami" {}
variable "instance_type" {}
variable "key_name" {
    sensitive = true
}
variable "domain-name" {
    sensitive   = true
}
variable "serverhostname" {
    sensitive   = true
}
variable "DOCKER_LOGIN_ACCESS_TOKEN" {
    sensitive = true
}
variable "DOCKER_LOGIN_USERNAME" {
    sensitive = true
}

variable "domain-owner-email" {
    sensitive   = true
}
variable "SLACK_CHANNEL" {
    sensitive   = true
}
variable "SLACK_USER" {
    sensitive   = true
}
variable "SLACK_URL" {
    sensitive   = true
}
