resource "aws_instance" "swarm-manager" {
    ami           = var.ami
    instance_type = var.instance_type
    user_data_base64 = base64encode(templatefile("init.sh", {

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