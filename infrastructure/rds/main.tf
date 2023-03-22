resource "random_password" "rds"{
  length           = 16
  special          = true
  override_special = "_!%^"
}


resource "aws_db_instance" "rds" {
    port                      = "3306"
    allocated_storage         = "10"
    storage_type              = "gp2"
    engine                    = "mysql"
    engine_version            = ""
    instance_class            = "db.t3.micro"
    identifier                = var.name
    username                  = var.rds-username
    password                  = random_password.rds.result
    deletion_protection       = false
    final_snapshot_identifier = var.name
    snapshot_identifier       = ""
    skip_final_snapshot       = true
    option_group_name         = ""
    ca_cert_identifier        = "rds-ca-2019"


    multi_az                              = false
    availability_zone                     = ""
    storage_encrypted                     = false
    copy_tags_to_snapshot                 = true
    allow_major_version_upgrade           = false
    auto_minor_version_upgrade            = true
    apply_immediately                     = true
    maintenance_window                    = "Mon:03:00-Mon:04:00"
    backup_retention_period               = 1
    backup_window                         = "22:00-03:00"
    vpc_security_group_ids                = [aws_security_group.rds.id]
    publicly_accessible                   = true
    performance_insights_enabled          = false
    performance_insights_retention_period = 0
    monitoring_interval                   = 0

    tags = {
        Name = "${var.name}"
    }
}


resource "aws_security_group" "rds" {
    name        = "${var.name}"
    description = "${var.name}"

    # ingress {
    #     from_port       = 3306
    #     to_port         = 3306
    #     protocol        = "TCP"
    #     cidr_blocks     = ["${chomp(data.http.provisioner-ip.response_body)}/32"]
    # }

    ingress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "TCP"
        cidr_blocks     = ["${chomp(data.http.provisioner-ip.response_body)}/32"]
        description     = "access by provisioner"
    }

    ingress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "TCP"
        self = true
        description     = "access by itself"
    }

    egress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name}"
    }
}


resource "aws_route53_record" "rds" {
    zone_id = data.aws_route53_zone.primary.zone_id
    name    = "${var.name}.${var.domain-name}"
    type    = "CNAME"
    ttl     = 100
    records = [aws_db_instance.rds.address]
}


resource "aws_secretsmanager_secret" "rds" {
    name = "${var.name}"

    tags = {
        Name = "${var.name}"
    }

    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_secretsmanager_secret_version" "rds" {
    secret_id     = aws_secretsmanager_secret.rds.id
    secret_string = jsonencode(
        {
            username = var.rds-username
            password = random_password.rds.result
            engine   = "mysql"
            host     = "${aws_route53_record.rds.name}"
            port     = "3306"
        }
    )
}


resource "local_sensitive_file" "rds_descriptor" {
    content  = templatefile("./rds_descriptor.sh",
        {
            username = var.rds-username
            password = random_password.rds.result
            host     = "${aws_route53_record.rds.name}"
            port     = "3306"
        }
    )
    filename = "~~rds_descriptor.sh"
}
