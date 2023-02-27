module "swarm_node_01" {
    source          = "./module"
    name            ="swarm_node_01"
    instance_type   = "t2.small"
    ami             = var.ami
    key_name        = var.key_name
    domain-name        = var.domain-name
}