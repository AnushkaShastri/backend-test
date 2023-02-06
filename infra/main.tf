provider "aws" {
  region = var.region
  default_tags {
    tags = {
      createdBy        = var.createdBy
      project          = var.project
      projectComponent = var.projectComponent
    }
  }
}
terraform {
  backend "http" {
    update_method = "POST"
    lock_method   = "POST"
    unlock_method = "POST"
  }
}
resource "aws_s3_bucket" "logs" {
  bucket        = "${var.env}-${var.log_bucket_name}"
  force_destroy = var.log_bucket_force_destroy
}
resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.logs.id
  acl    = var.log_bucket_access_control
}

resource "aws_s3_bucket" "deployment" {
  bucket        = "${var.env}-${var.deployment_bucket_name}"
  force_destroy = var.deployment_bucket_force_destroy
}

resource "aws_s3_bucket_acl" "deployment_bucket_acl" {
  bucket = aws_s3_bucket.deployment.id
  acl    = var.deployment_bucket_access_control
}

resource "aws_s3_bucket_website_configuration" "web_config" {
  bucket = aws_s3_bucket.deployment.bucket
  index_document {
    suffix = var.index_document
  }
  error_document {
    key = var.error_document
  }
}

resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.deployment.id
  policy = data.aws_iam_policy_document.allow_access.json
}

data "aws_iam_policy_document" "allow_access" {
  statement {
    sid = "AllowPublicRead"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.deployment.arn}/*",
    ]
  }
}

resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = aws_s3_bucket.deployment.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.deployment.bucket}"

    custom_origin_config {
      origin_protocol_policy = var.origin_protocol_policy
      http_port              = var.http_port
      https_port             = var.https_port
      origin_ssl_protocols   = var.origin_ssl_protocols
    }
  }
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  default_root_object = var.default_root_object

  logging_config {
    include_cookies = var.include_cookies
    prefix          = var.prefix
    bucket          = aws_s3_bucket.logs.bucket_domain_name
  }

  custom_error_response {
    error_caching_min_ttl = var.error_caching_min_ttl
    error_code            = var.error_code
    response_code         = var.response_code
    response_page_path    = var.response_page_path
  }
  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = "S3-${aws_s3_bucket.deployment.bucket}"
    forwarded_values {
      query_string = var.query_string
      cookies {
        forward = var.forward
      }
    }
    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }

  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
    }
  }


  viewer_certificate {
    cloudfront_default_certificate = var.cloudfront_default_certificate
  }
}
