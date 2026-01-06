variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "network_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "labels" {
  type    = map(string)
  default = {}
}
