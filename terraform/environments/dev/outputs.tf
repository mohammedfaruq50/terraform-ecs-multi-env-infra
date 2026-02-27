output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "frontend_target_group_arn" {
  value = module.alb.frontend_target_group_arn
}

output "backend_target_group_arn" {
  value = module.alb.backend_target_group_arn
}

output "alb_security_group_id" {
  value = module.alb.alb_security_group_id
}