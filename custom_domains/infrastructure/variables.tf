variable "hosted_zone" {
  type = map(any)
}

variable "tags" {
}

variable "delegation_name" {
  default = null
}

variable "delegation_ns" {
  default = null
}
