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

locals {
  iam_policy_name          = (var.iam_policy_name == "null" || var.iam_policy_name == null) ? null : "${var.env}-${var.iam_policy_name}"
  iam_policy_prefix        = (var.iam_policy_prefix == "null" || var.iam_policy_prefix == null) ? null : var.iam_policy_prefix
  iam_role_description     = var.iam_role_description == "null" ? null : var.iam_role_description
  force_detach_policies    = var.force_detach_policies == "null" ? null : var.force_detach_policies
  max_session_duration     = var.max_session_duration == "null" ? null : var.max_session_duration
  iam_path                 = var.iam_path == "null" ? null : var.iam_path
  iam_role_name            = (var.iam_role_name == "null" || var.iam_role_name == null) ? null : "${var.env}-${var.iam_role_name}"
  iam_role_prefix          = (var.iam_role_prefix == "null" || var.iam_role_prefix == null) ? null : "${var.env}-${var.iam_role_prefix}"
  ecr_force_delete         = var.ecr_force_delete == "null" ? null : var.ecr_force_delete
  image_tag_mutability     = var.image_tag_mutability == "null" ? null : var.image_tag_mutability
  auto_deployments_enabled = var.auto_deployments_enabled == "null" ? null : var.auto_deployments_enabled
  image_start_command      = var.image_start_command == "null" ? null : var.image_start_command
  auto_scaling_configuration_arn = var.auto_scaling_configuration_arn == "null" ? null : var.auto_scaling_configuration_arn
}

resource "aws_iam_role_policy" "app_policy" {
  name        = local.iam_policy_name
  name_prefix = local.iam_policy_prefix
  role        = aws_iam_role.role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "apprunner:CreateService",
          "apprunner:Describe*",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:DescribeImages",
          "ecr:GetAuthorizationToken"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "role" {
  assume_role_policy    = <<EOF
  {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": [
              "build.apprunner.amazonaws.com",
              "tasks.apprunner.amazonaws.com"
            ]
          },
          "Effect": "Allow",
          "Sid": "s1"
        }
      ]
    }
    EOF
  description           = local.iam_role_description
  force_detach_policies = local.force_detach_policies
  max_session_duration  = local.max_session_duration
  path                  = local.iam_path
  name                  = local.iam_role_name
  name_prefix           = local.iam_role_prefix
  tags                  = var.iam_role_tags
}

resource "aws_ecr_repository" "app_container_ecr_repo" {
  name = "${var.env}-${var.reponame}"
  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration
    content {
      encryption_type = lookup(encryption_configuration.value, "encryption_type", null)
      kms_key         = lookup(encryption_configuration.value, "kms_key", null)
    }
  }
  force_delete         = local.ecr_force_delete
  image_tag_mutability = local.image_tag_mutability
  dynamic "image_scanning_configuration" {
    for_each = length(var.image_scanning_configuration) == 0 ? [] : [var.image_scanning_configuration]
    content {
      scan_on_push = lookup(image_scanning_configuration.value, "scan_on_push", null)
    }
  }
  tags = var.ecr_tags
}

resource "aws_ecr_repository_policy" "app_container_ecr_repo_policy" {
  repository = aws_ecr_repository.app_container_ecr_repo.name
  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "adds full ecr access to the demo repository",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:GetAuthorizationToken"
        ]
      }
    ]
  }
  EOF
}

resource "aws_apprunner_service" "app_node_ping" {
  service_name = "${var.env}-${var.apprunner_service_name}"
  depends_on   = [aws_iam_role.role]
  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.role.arn
    }
    auto_deployments_enabled = local.auto_deployments_enabled
    image_repository {
      image_configuration {
        port                          = var.image_port
        runtime_environment_secrets   = var.image_runtime_environment_secrets
        runtime_environment_variables = var.image_runtime_environment_variables
        start_command                 = local.image_start_command
      }
      image_identifier      = "${aws_ecr_repository.app_container_ecr_repo.repository_url}:${var.image_tag}"
      image_repository_type = var.image_repository_type
    }
  }
  auto_scaling_configuration_arn = local.auto_scaling_configuration_arn
  dynamic "encryption_configuration" {
    for_each = length(var.apprunner_encryption_configuration) == 0 ? [] : [var.apprunner_encryption_configuration]
    content {
      kms_key = lookup(encryption_configuration.value, "encryption_kms_key", null)
    }
  }
  dynamic "health_check_configuration" {
    for_each = length(var.health_check_configuration) == 0 ? [] : [var.health_check_configuration]
    content {
      healthy_threshold   = lookup(health_check_configuration.value, "healthy_threshold", null)
      interval            = lookup(health_check_configuration.value, "health_interval", null)
      path                = lookup(health_check_configuration.value, "health_path", null)
      protocol            = lookup(health_check_configuration.value, "health_protocol", null)
      timeout             = lookup(health_check_configuration.value, "health_timeout", null)
      unhealthy_threshold = lookup(health_check_configuration.value, "unhealthy_threshold", null)
    }
  }
  dynamic "instance_configuration" {
    for_each = length(var.instance_configuration) == 0 ? [] : [var.instance_configuration]
    content {
      cpu               = lookup(instance_configuration.value, "instance_cpu", null)
      instance_role_arn = lookup(instance_configuration.value, "instance_role_arn", null)
      memory            = lookup(instance_configuration.value, "instance_memory", null)
    }
  }
  dynamic "network_configuration" {
    for_each = length(var.network_configuration) == 0 ? [] : [var.network_configuration]
    content {
      ingress_configuration {
        is_publicly_accessible = lookup(network_configuration.value, "is_publicly_accessible", null)
      }
      egress_configuration {
        egress_type       = lookup(network_configuration.value, "egress_type", null)
        vpc_connector_arn = lookup(network_configuration.value, "vpc_connector_arn", null)
      }
    }
  }
  dynamic "observability_configuration" {
    for_each = length(var.observability_configuration) == 0 ? [] : [var.observability_configuration]
    content {
      observability_enabled           = lookup(observability_configuration.value, "observability_enabled", null)
      observability_configuration_arn = lookup(observability_configuration.value, "observability_configuration_arn", null)
    }
  }
  tags = var.apprunner_tags
}
