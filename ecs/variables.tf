variable "Cluster-name" {} 

variable "family-name" {
  type = string
}

variable "container-name" {
  type = string
}

variable "image-name" {
  type = string
}

variable "lb-name" {
  type = string
}

variable "targerG-name" {
  type = string
}

variable "iam-role-name" {}

variable "ecs-type" {}

variable "desired_count" {}

variable "subnets" {
  type = list(any)
}
variable "scg-ecs" {}

//taskdefinition variables
//variable "network" {}
variable "cpu" {}
variable "memory" {}
variable "file" {}
variable "OS" {}
variable "alb-arn" {}