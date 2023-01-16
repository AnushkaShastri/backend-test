output "app_runner_url" {
  value = "https://${aws_apprunner_service.app_node_ping.service_url}/api/ping"
}