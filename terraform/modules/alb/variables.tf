variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for ALB"
  type        = list(string)
}

variable "frontend_port" {
  description = "Frontend container port"
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Backend container port"
  type        = number
  default     = 3000
}

variable "alb_deletion_protect" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}