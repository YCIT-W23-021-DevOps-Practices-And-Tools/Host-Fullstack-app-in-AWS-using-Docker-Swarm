data "aws_route53_zone" "primary" {
    name = var.domain-name
}

data "aws_secretsmanager_secret" "store-master-key-in-sm" {
    name = var.key_name
}

data "aws_secretsmanager_secret_version" "store-master-key-in-sm" {
    secret_id = data.aws_secretsmanager_secret.store-master-key-in-sm.id
}