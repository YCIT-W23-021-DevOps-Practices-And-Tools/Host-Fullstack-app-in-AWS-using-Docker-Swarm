resource "random_password" "password" {
    length           = 55
    special          = false
}

resource "aws_secretsmanager_secret" "swarm-master-password" {
    name = "swarm-master-password"
    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_secretsmanager_secret_version" "swarm-master-password-key-in-sm" {
    secret_id     = aws_secretsmanager_secret.swarm-master-password.id
    secret_string = random_password.password.result
    lifecycle {
        prevent_destroy = true
    }
}