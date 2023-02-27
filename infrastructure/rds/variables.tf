variable "name" {}
variable "domain-name" {
    sensitive   = true
}
variable "rds-username" {
    sensitive   = true
}