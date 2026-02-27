provider "aws" {
  region = "us-west-2"
}

# # Call remote state module (creates S3 bucket + DynamoDB if you want)
# module "remote_state" {
#   source          = "../../modules/remote_state"
#   bucket_name     = "faruqs3bucket"

#   environment     = var.environment_name
# }

module "backend_ecr" {
  source = "../../modules/ecr"
  repository_name = "dev/backend"
}

module "frontend_ecr" {
  source = "../../modules/ecr"
  repository_name = "dev/frontend"
}


module "vpc" {
  source = "../../modules/vpc"

  environment     = "dev"
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  azs             = ["us-west-2a", "us-west-2b"]
}

# Application load balancer for the dev environment
module "alb" {
  source            = "../../modules/alb"
  environment       = "dev"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

# ECS Cluster for the dev environment
module "ecs_cluster" {
  source      = "../../modules/ecs-cluster"
  environment = "dev"
}

# Backend ECS Service for the dev environment
module "backend_service" {
  source                = "../../modules/ecs-service"
  environment           = "dev"
  service_name          = "backend"
  cluster_arn           = module.ecs_cluster.cluster_arn
  subnet_ids            = module.vpc.private_subnet_ids
  target_group_arn      = module.alb.backend_target_group_arn
  alb_security_group_id = module.alb.alb_security_group_id
  container_image       = "202059357459.dkr.ecr.us-west-2.amazonaws.com/dev/backend:latest"
  container_port        = 3000
  cpu                   = 256
  memory                = 512
  desired_count         = 1
  region                = "us-west-2"
  vpc_id                = module.vpc.vpc_id
}

module "frontend_service" {
  source                = "../../modules/ecs-service"
  environment           = "dev"
  service_name          = "frontend"
  cluster_arn           = module.ecs_cluster.cluster_arn
  subnet_ids            = module.vpc.private_subnet_ids
  target_group_arn      = module.alb.frontend_target_group_arn
  alb_security_group_id = module.alb.alb_security_group_id
  container_image       = "202059357459.dkr.ecr.us-west-2.amazonaws.com/dev/frontend:v3"
  container_port        = 3000
  cpu                   = 256
  memory                = 512
  desired_count         = 1
  region                = "us-west-2"
  vpc_id                = module.vpc.vpc_id
}