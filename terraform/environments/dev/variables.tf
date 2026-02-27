variable "environment_name" {
  description = "Name of the environment"
  type        = string
  default     = "dev"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "my-app-repo"
}
