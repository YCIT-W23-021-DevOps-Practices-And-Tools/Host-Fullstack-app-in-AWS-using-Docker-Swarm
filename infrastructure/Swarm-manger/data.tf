data "aws_route53_zone" "primary" {
  name = var.domain-name
}
