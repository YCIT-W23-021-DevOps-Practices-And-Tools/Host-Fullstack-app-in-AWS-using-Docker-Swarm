resource "aws_instance" "swarm-manager" {
    ami           = var.ami
    instance_type = var.instance_type
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
