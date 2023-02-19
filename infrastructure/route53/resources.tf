resource "aws_route53_zone" "primary" {
    name = var.domain-name
    lifecycle {
        prevent_destroy = true
    }
}