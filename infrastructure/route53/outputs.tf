output "name_servers" {
    description = "name_servers"
    value = aws_route53_zone.primary.name_servers
}

output "primary_name_server" {
    description = "primary_name_server"
    value = aws_route53_zone.primary.primary_name_server
}