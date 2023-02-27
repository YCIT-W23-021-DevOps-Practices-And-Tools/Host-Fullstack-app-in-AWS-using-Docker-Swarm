module "swarm_node_01" {
    source          = "./module"
    name            ="swarm_node_01"
    instance_type   = "t2.small"
    ami             = var.ami
    key_name        = var.key_name
    domain-name        = var.domain-name
    serverhostname="swarm_node_01.${var.domain-name}"
    DOCKER_LOGIN_ACCESS_TOKEN=var.DOCKER_LOGIN_ACCESS_TOKEN
    DOCKER_LOGIN_USERNAME=var.DOCKER_LOGIN_USERNAME
}

# module "swarm_node_02" {
#     source          = "./module"
#     name            ="swarm_node_02"
#     instance_type   = "t2.small"
#     ami             = var.ami
#     key_name        = var.key_name
#     domain-name        = var.domain-name
#     serverhostname="swarm_node_02.${var.domain-name}"
#     DOCKER_LOGIN_ACCESS_TOKEN=var.DOCKER_LOGIN_ACCESS_TOKEN
#     DOCKER_LOGIN_USERNAME=var.DOCKER_LOGIN_USERNAME
# }

# module "swarm_node_03" {
#     source          = "./module"
#     name            ="swarm_node_03"
#     instance_type   = "t2.small"
#     ami             = var.ami
#     key_name        = var.key_name
#     domain-name        = var.domain-name
#     serverhostname="swarm_node_03.${var.domain-name}"
#     DOCKER_LOGIN_ACCESS_TOKEN=var.DOCKER_LOGIN_ACCESS_TOKEN
#     DOCKER_LOGIN_USERNAME=var.DOCKER_LOGIN_USERNAME
# }

# module "swarm_node_04" {
#     source          = "./module"
#     name            ="swarm_node_04"
#     instance_type   = "t2.small"
#     ami             = var.ami
#     key_name        = var.key_name
#     domain-name        = var.domain-name
#     serverhostname="swarm_node_04.${var.domain-name}"
#     DOCKER_LOGIN_ACCESS_TOKEN=var.DOCKER_LOGIN_ACCESS_TOKEN
#     DOCKER_LOGIN_USERNAME=var.DOCKER_LOGIN_USERNAME
# }
