variable "instance_name" {
    type = string
}

variable "region" {
    type = string
}

variable "machine_type"{
    type = string
}

variable "image_name"{
    type = string
    default = "Debian 12"
}

variable "key_pair_name" {
    type = string
}

variable "security_group" {
    type = string
}

variable "ansible_playbook" {
    type = string

    default = ""
}

variable "metadata" {
    type = map

    default = {}
}