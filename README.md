# T-Modules
Terraform modules 
- ECR
- ECS 
- ALB

keep on mind if you want to created the an ecs with ALB, you will need to add a depends on for the alb.
alb needs to be created before ecs.

eg:
```
module "ecs-task-role" {
  source         = "../modules/ecs"
  Cluster-name   = "cluster-name"
  family-name    = "example"
  container-name = "container-name"                                   
  image-name     = "account.dkr.ecr.eu-west-2.amazonaws.com/image-name"
  lb-name        = "ecs"
  targerG-name   = "test"
  iam-role-name  = "ecs-role-test"
  ecs-type       = "FARGATE"
  desired_count  = 1

  subnets = [module.vpc.public_subnet_az1_id, module.vpc.public_subnet_az2_id]
  alb-arn = module.alb.alb-arn

  file    = file("container-definition.json")
  cpu     = "1024"
  memory  = 2048
  OS      = "LINUX"
  scg-ecs = module.sps-ecs.sg-id
  depends_on = [ module.alb ]
}

module "alb" {
  source             = "../modules/alb"
  lb-name            = "alb-test"
  inter-ext          = "false"
  load_balancer_type = "application"
  security_groups    = module.sps.sg-id
  subnets            = [module.vpc.public_subnet_az1_id, module.vpc.public_subnet_az2_id]
  #certificate =
  vpc_id      = module.vpc.vpc_id
  target-name = "target-test"
}

# The module will build the image locally and push it to AWS. 
# The user should ensure they have the correct path for the Dockerfile.

module "ecr" {
  source = "../modules/ECR"
  region = var.region
  repository_list = ["worker"]
  path-file       = "../docker/"
}


```