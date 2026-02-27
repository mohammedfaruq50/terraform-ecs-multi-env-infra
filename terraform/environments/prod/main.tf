provider "aws" {
  region = "us-west-2"
}

module "backend_ecr" {
  source = "../../modules/ecr"
  repository_name = "prod/backend"
}

module "frontend_ecr" {
  source = "../../modules/ecr"
  repository_name = "prod/frontend"
}


module "vpc" {
  source = "../../modules/vpc"

  environment     = var.environment
  vpc_cidr        = "10.30.0.0/16"

  public_subnets  = ["10.30.1.0/24", "10.30.2.0/24"]
  private_subnets = ["10.30.3.0/24", "10.30.4.0/24"]

  azs             = ["us-west-2a", "us-west-2b"]
}

module "alb" {
  source            = "../../modules/alb"
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

  alb_deletion_protect = true
}

module "ecs_cluster" {
  source      = "../../modules/ecs-cluster"
  environment = var.environment
}

module "backend_service" {
  source                = "../../modules/ecs-service"
  environment           = var.environment
  service_name          = "backend"
  cluster_arn           = module.ecs_cluster.cluster_arn
  subnet_ids            = module.vpc.private_subnet_ids
  target_group_arn      = module.alb.backend_target_group_arn
  alb_security_group_id = module.alb.alb_security_group_id

  container_image       = "${module.backend_ecr.repository_url}:latest"
  container_port        = 3000

  cpu                   = 512
  memory                = 1024
  desired_count         = 2

  region                = "us-west-2"
  vpc_id                = module.vpc.vpc_id
}


module "frontend_service" {
  source                = "../../modules/ecs-service"
  environment           = var.environment
  service_name          = "frontend"
  cluster_arn           = module.ecs_cluster.cluster_arn
  subnet_ids            = module.vpc.private_subnet_ids
  target_group_arn      = module.alb.frontend_target_group_arn
  alb_security_group_id = module.alb.alb_security_group_id

  container_image       = "${module.frontend_ecr.repository_url}:v3"
  container_port        = 3000

  cpu                   = 512
  memory                = 1024
  desired_count         = 2

  region                = "us-west-2"
  vpc_id                = module.vpc.vpc_id
}


module "backend_autoscaling" {
  source       = "../../modules/autoscaling"
  cluster_name = module.ecs_cluster.cluster_name
  service_name = "prod-backend-service"
  min_capacity = 2
  max_capacity = 5
}

module "frontend_autoscaling" {
  source       = "../../modules/autoscaling"
  cluster_name = module.ecs_cluster.cluster_name
  service_name = "prod-frontend-service"
  min_capacity = 2
  max_capacity = 5
}