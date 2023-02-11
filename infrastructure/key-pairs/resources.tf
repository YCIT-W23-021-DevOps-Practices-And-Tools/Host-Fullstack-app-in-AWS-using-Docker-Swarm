
# Create a rsa key and store it in the state manger
resource "tls_private_key" "rsa" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

# Save the public key in the local folder 
resource "local_file" "master-key-pub" {
    content  = tls_private_key.rsa.public_key_openssh
    filename = "~~${var.key_name}.pub"
}

# Save the private key in the local folder 
resource "local_file" "master-key-private" {
    content  = tls_private_key.rsa.private_key_pem
    filename = "~~${var.key_name}.pem"
}

# Provision a new key pair in ec2 section of AWS
resource "aws_key_pair" "master-key-pair" {
    key_name = var.key_name
    public_key = tls_private_key.rsa.public_key_openssh
    tags = {
        Name = var.key_name
    }
}

# Provision a secret in AWS secret manager
resource "aws_secretsmanager_secret" "store-master-key-in-sm" {
    name = var.key_name
}

# Add Private key value in to above secret
resource "aws_secretsmanager_secret_version" "store-master-key-in-sm" {
    secret_id     = aws_secretsmanager_secret.store-master-key-in-sm.id
    secret_string = tls_private_key.rsa.private_key_pem
}