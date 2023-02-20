resource "aws_instance" "swarm-manager" {
    ami           = var.ami
    instance_type = var.instance_type
    user_data_base64 = base64encode(templatefile("init.sh", {
        serverhostname=var.serverhostname
        DOCKER_LOGIN_ACCESS_TOKEN=var.DOCKER_LOGIN_ACCESS_TOKEN
        DOCKER_LOGIN_USERNAME=var.DOCKER_LOGIN_USERNAME
        PRIVATE_SSH_KEY=data.aws_secretsmanager_secret_version.store-master-key-in-sm.secret_string
        domain-owner-email=var.domain-owner-email
        domain-name=var.domain-name
        swarm-master-password=random_password.password.result
    }))

    user_data_replace_on_change = true
    key_name      = var.key_name

    associate_public_ip_address = true

    vpc_security_group_ids = [
        aws_security_group.swarm-manager-internet-and-ssh.id,
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


resource "aws_security_group" "swarm-manager-internet-and-ssh" {
    name       = "security-group-swarm-servers-internet-and-ssh"
    tags = {
        Name     = "security-group-swarm-servers-internet-and-ssh"
    }

    ingress {
        from_port       = 0
        to_port         = 0
        protocol        = -1
        self = true
    }

    ingress {
        from_port         = 22
        to_port           = 22
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
    }

    ingress {
        from_port         = 80
        to_port           = 80
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
    }

    ingress {
        from_port         = 443
        to_port           = 443
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
    }



    egress {
        from_port       = 0
        to_port         = 0
        protocol        = -1
        cidr_blocks     = ["0.0.0.0/0"]
    }
}

resource "aws_route53_record" "private" {
    zone_id = data.aws_route53_zone.primary.zone_id
    name    = "swarm-manager.private.${var.domain-name}"
    type    = "A"
    ttl     = 100
    records = [aws_instance.swarm-manager.private_ip]
}

resource "aws_route53_record" "public" {
    zone_id = data.aws_route53_zone.primary.zone_id
    name    = "swarm-manager.public.${var.domain-name}"
    type    = "A"
    ttl     = 100
    records = [aws_instance.swarm-manager.public_ip]
}

resource "aws_route53_record" "swarm-manager" {
    zone_id = data.aws_route53_zone.primary.zone_id
    name    = "swarm-manager.${var.domain-name}"
    type    = "CNAME"
    ttl     = 100
    records = [aws_route53_record.public.name]
}

resource "aws_route53_record" "traefik" {
    zone_id = data.aws_route53_zone.primary.zone_id
    name    = "traefik.${var.domain-name}"
    type    = "CNAME"
    ttl     = 300
    records = [aws_route53_record.public.name]
}