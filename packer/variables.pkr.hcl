variable "vm_name" {
  type    = string
  default = "rocky9-golden"
}

variable "iso_path" {
  type    = string
  default = "d:/iso/Rocky-9.7-x86_64-dvd.iso"
}

variable "ssh_username" {
  type    = string
  default = "ansible"
}

variable "ssh_password" {
  type    = string
  default = "changeme"
}
