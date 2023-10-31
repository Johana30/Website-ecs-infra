variable "lb-name" {}
variable "inter-ext" {}
variable "load_balancer_type" {}
variable "security_groups" {}
variable "subnets" {
  type = list(any)
}
#variable "certificate" {}
variable "vpc_id" {}
variable "target-name" {}