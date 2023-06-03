output "app_runner_url" {
  value = aws_apprunner_service.app_node_ping.service_url
}