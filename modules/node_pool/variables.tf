variable "node_pool_name" {
  type = string
}

variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "node_count" {
  type    = number
  default = 1
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "service_account" {
  type    = string
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = list(string)
  default = []
}
