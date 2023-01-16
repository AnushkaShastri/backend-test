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

resource "aws_iam_role_policy" "app_policy" {
  name = "${var.env}-${var.iam_policy_name}"
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
}

resource "aws_iam_role" "role" {
  name = "${var.env}-${var.iam_role_name}"
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
          "Sid": ""
        }
      ]
    }
    EOF
}

resource "aws_ecr_repository" "app_container_ecr_repo" {
  name = "${var.env}-${var.repo_name}"
  image_tag_mutability = var.image_tag_mutability
  force_delete = var.force_delete
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
  
  source_configuration {
    image_repository {
      image_configuration {
        port = var.port
      }
      image_identifier      = "${aws_ecr_repository.app_container_ecr_repo.repository_url}:${var.image_tag}" 
      image_repository_type = "ECR"
    }
    authentication_configuration{
      access_role_arn = aws_iam_role.role.arn
    }
    auto_deployments_enabled = var.auto_deployments_enabled
  }

  tags = {
    Name = "Backend-apprunner-service"
  }
}