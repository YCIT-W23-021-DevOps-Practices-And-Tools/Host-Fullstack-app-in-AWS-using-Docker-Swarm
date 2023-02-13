resource "aws_instance" "swarm-manager" {
    ami           = var.ami
    instance_type = var.instance_type
    key_name      = var.key_name

    associate_public_ip_address = true


    tags = {
        Name = var.name
    }

    root_block_device {
        encrypted = true
    }

    lifecycle {
        create_before_destroy = true
    }

}