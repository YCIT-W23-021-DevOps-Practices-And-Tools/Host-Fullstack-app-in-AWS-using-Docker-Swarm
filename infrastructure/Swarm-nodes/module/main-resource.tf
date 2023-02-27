resource "aws_instance" "swarm-node" {
    ami           = var.ami
    instance_type = var.instance_type
    user_data_base64 = base64encode(templatefile("./module/init.sh", {
        serverhostname=var.serverhostname
        DOCKER_LOGIN_ACCESS_TOKEN=var.DOCKER_LOGIN_ACCESS_TOKEN
        DOCKER_LOGIN_USERNAME=var.DOCKER_LOGIN_USERNAME
        PRIVATE_SSH_KEY=data.aws_secretsmanager_secret_version.store-master-key-in-sm.secret_string
    }))

    user_data_replace_on_change = true
    key_name      = var.key_name

    associate_public_ip_address = true

    vpc_security_group_ids = [
        data.aws_security_group.swarm-manager-internet-and-ssh.id,
    ]


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


resource "aws_route53_record" "private" {
    zone_id = data.aws_route53_zone.primary.zone_id
    name    = "${var.name}.private.${var.domain-name}"
    type    = "A"
    ttl     = 100
    records = [aws_instance.swarm-node.private_ip]
}

resource "aws_route53_record" "public" {
    zone_id = data.aws_route53_zone.primary.zone_id
    name    = "${var.name}.public.${var.domain-name}"
    type    = "A"
    ttl     = 100
    records = [aws_instance.swarm-node.public_ip]
}

resource "aws_route53_record" "host-name" {
    zone_id = data.aws_route53_zone.primary.zone_id
    name    = "${var.name}.${var.domain-name}"
    type    = "A"
    ttl     = 100
    records = [aws_instance.swarm-node.public_ip]
}
