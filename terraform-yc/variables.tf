variable "flow" {
  type    = string
  default = "cicd-51"
}

variable "cloud_id" {
  type    = string
  default = "b1gerfjflbv9468d1ti6"
}
variable "folder_id" {
  type    = string
  default = "b1gpo0761hhdt23vcd7p"
}

variable "test" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
}

