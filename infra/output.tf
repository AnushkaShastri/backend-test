output "app_runner_url" {
    value = "https://${aws_apprunner_service.app_python_ping.service_url}"
  }