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
  # iam_policy_description = var.iam_policy_description == "null" ? null : var.iam_policy_description
  iam_policy_name = (var.iam_policy_name == "null" || var.iam_policy_name == null) ? null : "${var.env}-${var.iam_policy_name}"
  iam_policy_prefix = (var.iam_policy_prefix == "null" || var.iam_policy_prefix == null) ? null : var.iam_policy_prefix
  # iam_path = var.iam_path == "null" ? null : var.iam_path
  iam_role_description = var.iam_role_description == "null" ? null : var.iam_role_description
  iam_role_name = (var.iam_role_name == "null" || var.iam_role_name == null) ? null : "${var.env}-${var.iam_role_name}"
  iam_role_prefix = (var.iam_role_prefix == "null" || var.iam_role_prefix == null) ? null : "${var.env}-${var.iam_role_prefix}"
  iam_role_path = var.iam_role_path == "null" ? null : var.iam_role_path
  permissions_boundary = var.permissions_boundary == "null" ? null : var.permissions_boundary
  encryption_type = var.encryption_type == "null" ? null : var.encryption_type
  kms_key = var.kms_key == "null" ? null : var.kms_key
  code_repository = var.code_repository == false ? [] : [{}]
  build_command = var.build_command == "null" ? null : var.build_command
  apprunner_port = var.apprunner_port == "null" ? null : var.apprunner_port
  runtime = var.runtime == "null" ? null : var.runtime
  runtime_environment_secrets = var.runtime_environment_secrets == "null" ? null : var.runtime_environment_secrets
  runtime_environment_variables = var.runtime_environment_variables == "null" ? null : var.runtime_environment_variables
  start_command = var.start_command == "null" ? null : var.start_command
  configuration_source = var.configuration_source == "null" ? null : var.configuration_source
  repository_url = var.repository_url == "null" ? null : var.repository_url
  image_repository = var.image_repository == false ? [] : [{}]
  image_runtime_environment_secrets = var.image_runtime_environment_secrets == "null" ? null : var.image_runtime_environment_secrets
  image_runtime_environment_variables = var.image_runtime_environment_variables == "null" ? null : var.image_runtime_environment_variables
  image_start_command = var.image_start_command == "null" ? null : var.image_start_command
  encryption_kms_key = var.encryption_kms_key == "null" ? null : var.encryption_kms_key
  instance_role_arn = var.instance_role_arn == "null" ? null : var.instance_role_arn
  # egress_type = var.egress_type == "null" ? null : var.egress_type
  vpc_connector_arn = var.vpc_connector_arn == "null" ? null : var.vpc_connector_arn
  observability_configuration_arn = var.observability_configuration_arn == "null" ? null : var.observability_configuration_arn
} 

resource "aws_iam_role_policy" "app_policy" {
  # description = local.iam_policy_description
  name = local.iam_policy_name
  name_prefix = local.iam_policy_prefix
  # path = var.iam_policy_path
  role = aws_iam_role.role.id
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
  # tags = var.iam_policy_tags
}

resource "aws_iam_role" "role" {
  description = local.iam_role_description
  name = local.iam_role_name
  name_prefix = local.iam_role_prefix
  force_detach_policies = var.force_detach_policies
  # dynamic "inline_policy" {
  #   for_each = var.inline_policy
  #   content {
  #     name = inline_policy.value.inline_policy_name
  #     policy = inline_policy.value.inline_policy
  #   }
  # }
  managed_policy_arns = var.managed_policy_arns
  max_session_duration = var.max_session_duration
  assume_role_policy = <<EOF
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
  path = local.iam_role_path
  permissions_boundary = local.permissions_boundary
  tags = var.iam_role_tags
}

resource "aws_ecr_repository" "app_container_ecr_repo" {
  name = "${var.env}-${var.reponame}"
  encryption_configuration {
    encryption_type = local.encryption_type
    kms_key = local.kms_key
  }
  force_delete = var.force_delete
  image_tag_mutability = var.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
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
  depends_on = [aws_iam_role.role]
  source_configuration {
    authentication_configuration{
      access_role_arn = aws_iam_role.role.arn
      connection_arn = var.connection_arn
    }
    auto_deployments_enabled = var.auto_deployments_enabled
    dynamic "code_repository" {
      for_each = local.code_repository
      content {
        code_configuration {
        code_configuration_values {
          build_command = local.build_command
          port = local.apprunner_port
          runtime = local.runtime
          runtime_environment_secrets = local.runtime_environment_secrets
          runtime_environment_variables = local.runtime_environment_variables
          start_command = local.start_command
        }
        configuration_source = local.configuration_source
      }
      repository_url = local.repository_url
      source_code_version {
        type = var.source_code_type
        value = var.source_code_value
      }
      }
    }
    dynamic "image_repository" {
      for_each = local.image_repository
      content {
        image_configuration {
        port = var.port
        runtime_environment_secrets = local.image_runtime_environment_secrets
        runtime_environment_variables = local.image_runtime_environment_variables
        start_command = local.image_start_command
      }
      image_identifier      = "${aws_ecr_repository.app_container_ecr_repo.repository_url}:${var.image_tag}" 
      image_repository_type = var.image_repository_type
      }
    }
  }
  auto_scaling_configuration_arn = var.auto_scaling_configuration_arn
  encryption_configuration {
    kms_key = local.encryption_kms_key
  }
  health_check_configuration {
    healthy_threshold = var.healthy_threshold
    interval = var.interval
    path = var.health_path
    protocol = var.health_protocol
    timeout = var.health_timeout
    unhealthy_threshold = var.unhealthy_threshold
  }
  instance_configuration {
    cpu = var.instance_cpu
    instance_role_arn = local.instance_role_arn
    memory = var.instance_memory
  }
  network_configuration {
    ingress_configuration {
      is_publicly_accessible = var.is_publicly_accessible
    }
    egress_configuration {
      egress_type = var.egress_type
      vpc_connector_arn = local.vpc_connector_arn
    }
  }
  observability_configuration {
    observability_enabled = var.observability_enabled 
    observability_configuration_arn = local.observability_configuration_arn 
  }
  tags = var.apprunner_tags
}