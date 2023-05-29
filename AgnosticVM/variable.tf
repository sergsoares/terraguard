variable "key_name" {
  type = string
  default = "wirekey"
}

variable "mobile" {
  type = bool
  default = false
}

variable "host" {
  type = string
}

variable "user" {
  type = string
  default = "root"
}

variable "ssh_key" {
  type = string
  default = "~/.ssh/id_rsa"
}