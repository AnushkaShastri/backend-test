output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.distribution.domain_name}/api/ping"
}