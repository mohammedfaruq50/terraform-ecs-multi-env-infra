output "service_name" {
  value = aws_ecs_service.service.name
}

output "security_group_id" {
  value = aws_security_group.ecs_sg.id
}