# output "role-name" {
#   description = "ECR url"
#   value = aws_ecr_repository.repository.repository_url
# }

output "role-name" {
  description = "ecr urls"
  value = [ for vnet in aws_ecr_repository.repository: vnet.repository_url]
}