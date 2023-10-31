variable "region" {}

variable "repository" {
  description = "repository names"
  type        = string
  default = null
}

variable "repository_list" {
  description = "List of repository names"
  type        = list(string)
  default = [ "null" ]
}

variable "path-file" {}