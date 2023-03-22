data "aws_route53_zone" "primary" {
    name = var.domain-name
}


# data "aws_security_group" "swarm-manager-internet-and-ssh" {
#     name = "security-group-swarm-servers-internet-and-ssh"
# }

data "http" "provisioner-ip" {
    url = "https://ipv4.icanhazip.com"
}
