## Create ECR repositories
# resource "aws_ecr_repository" "repository" {
#   name     = var.repository_list
# }

# ## Build and push Docker images to ECR
# resource "docker_registry_image" "creation" {
#    name     = "${aws_ecr_repository.repository.repository_url}:latest"
  
#   build {
#     context = "../docker/"
#     dockerfile = "worker.dockerfile"
#   }
# }

#repository list
resource "aws_ecr_repository" "repository" {
  for_each = toset(var.repository_list)
  name     = each.key
}

## Build and push Docker images to ECR
resource "docker_registry_image" "creation" {
    for_each = toset(var.repository_list)
   name     = "${aws_ecr_repository.repository[each.key].repository_url}:latest"
  
  build {
    context = var.path-file #"../docker/"
    dockerfile = "${each.key}.dockerfile"
  }
}