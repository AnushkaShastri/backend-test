provider "aws" {
  region = var.region
  # default_tags {
  #   tags = {
  #     createdBy        = var.createdBy
  #     project          = var.project
  #     projectComponent = var.projectComponent
  #   }
  # }
}

terraform {
  backend "http" {
    update_method = "POST"
    lock_method   = "POST"
    unlock_method = "POST"
  }
}

resource "aws_ecr_repository" "app_container_ecr_repo" {
  name                 = "${var.env}-${var.reponame}"
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete
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
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:DescribeImages",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  }
  EOF
}

resource "aws_ecs_cluster" "app_cluster" {
  name = "${var.env}-${var.clustername}"
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "${var.env}_${var.ecs_task_family}"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.env}_${var.ecs_task_family}",
      "image": "${aws_ecr_repository.app_container_ecr_repo.repository_url}",
      "essential": ${var.ecs_task_essential},
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "memory": ${var.memory},
      "cpu": ${var.cpu}
    }
  ]
  DEFINITION
  requires_compatibilities = ["EC2"]
  network_mode             = var.network_mode
  memory                   = var.memory
  cpu                      = var.cpu
  execution_role_arn       = "${aws_iam_role.app_ecsTaskExecutionRole.arn}"
}

resource "aws_iam_role" "app_ecsTaskExecutionRole" {
  name               = "${var.env}_${var.ecstaskrolename}"
  assume_role_policy = data.aws_iam_policy_document.app_ecsTaskExecutionRole_policy.json
}

data "aws_iam_policy_document" "app_ecsTaskExecutionRole_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "app_ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.app_ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "app_service" {
  name            = "${var.env}_${var.servicename}"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  launch_type     = var.launch_type
  desired_count   = var.desired_count
  load_balancer {
    target_group_arn = aws_lb_target_group.app_target_group.arn
    container_name   = aws_ecs_task_definition.app_task.family
    container_port   = var.container_port
  }
  network_configuration {
    subnets         = ["${aws_default_subnet.app_default_subnet_a.id}", "${aws_default_subnet.app_default_subnet_b.id}", "${aws_default_subnet.app_default_subnet_c.id}"]
    security_groups = ["${aws_security_group.app_service_security_group.id}"]
  }
}

resource "aws_security_group" "app_service_security_group" {
  ingress {
    from_port       = var.app_service_sg_ingress_from_port
    to_port         = var.app_service_sg_ingress_to_port
    protocol        = var.app_service_sg_ingress_protocol
    security_groups = ["${aws_security_group.app_load_balancer_security_group.id}"]
  }
  egress {
    from_port   = var.app_service_sg_egress_from_port
    to_port     = var.app_service_sg_egress_to_port
    protocol    = var.app_service_sg_egress_protocol
    cidr_blocks = var.app_service_sg_egress_cidr_blocks
  }
}

resource "aws_default_vpc" "app_default_vpc" {
}

resource "aws_default_subnet" "app_default_subnet_a" {
  availability_zone = var.regiona
}

resource "aws_default_subnet" "app_default_subnet_b" {
  availability_zone = var.regionb
}

resource "aws_default_subnet" "app_default_subnet_c" {
  availability_zone = var.regionc
}

resource "aws_alb" "app_application_load_balancer" {
  name               = "${var.env}-${var.lbname}"
  load_balancer_type = var.load_balancer_type
  subnets = [
    "${aws_default_subnet.app_default_subnet_a.id}",
    "${aws_default_subnet.app_default_subnet_b.id}",
    "${aws_default_subnet.app_default_subnet_c.id}"
  ]
  security_groups = ["${aws_security_group.app_load_balancer_security_group.id}"]
}

resource "aws_security_group" "app_load_balancer_security_group" {
  ingress {
    from_port        = var.lb_sg_ingress_from_port
    to_port          = var.lb_sg_ingress_to_port
    protocol         = var.lb_sg_ingress_protocol
    cidr_blocks      = var.lb_sg_ingress_cidr_blocks
    ipv6_cidr_blocks = var.lb_sg_ingress_ipv6_cidr_blocks
  }
  egress {
    from_port        = var.lb_sg_egress_from_port
    to_port          = var.lb_sg_egress_to_port
    protocol         = var.lb_sg_egress_protocol
    cidr_blocks      = var.lb_sg_egress_cidr_blocks
    ipv6_cidr_blocks = var.lb_sg_egress_ipv6_cidr_blocks
  }
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_lb_target_group" "app_target_group" {
  name        = "${var.env}${var.tgname}"
  port        = var.lb_tg_port
  protocol    = var.lb_tg_protocol
  target_type = var.target_type
  health_check {
    matcher             = var.matcher
    path                = var.path
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.timeout
    interval            = var.interval
    protocol            = var.lb_tg_health_protocol
  }
  vpc_id = aws_default_vpc.app_default_vpc.id
}

resource "aws_instance" "instance" {
  ami                    = var.image
  instance_type          = var.instance_type
  vpc_security_group_ids = ["${aws_security_group.app_load_balancer_security_group.id}"]
  user_data              = data.template_file.user_data.rendered
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
}

data "template_file" "user_data" {
  template = file("user_data.tpl")
  vars = {
    cluster_name = "${aws_ecs_cluster.app_cluster.name}"
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.env}_${var.ec2_role_name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.env}_${var.ec2_profile_name}"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy" "ec2_policy" {
  name   = "${var.env}_${var.ec2_policy_name}"
  role   = aws_iam_role.ec2_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:DescribeImages",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_alb.app_application_load_balancer.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol
  default_action {
    type             = var.lb_listener_type
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
}

resource "aws_appautoscaling_target" "app_as_ecs_target" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${aws_ecs_cluster.app_cluster.name}/${aws_ecs_service.app_service.name}"
  scalable_dimension = var.scalable_dimension
  service_namespace  = var.service_namespace
}

resource "aws_appautoscaling_policy" "app_as_ecs_policy_memory" {
  name               = "${var.env}_${var.aspolicyname}"
  policy_type        = var.policy_type_memory
  resource_id        = aws_appautoscaling_target.app_as_ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.app_as_ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.app_as_ecs_target.service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type_memory
    }
    target_value = var.target_value_memory
  }
}

resource "aws_appautoscaling_policy" "app_as_ecs_policy_cpu" {
  name               = "${var.env}_${var.appautoscaling_policy_name}"
  policy_type        = var.policy_type_cpu
  resource_id        = aws_appautoscaling_target.app_as_ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.app_as_ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.app_as_ecs_target.service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type_cpu
    }
    target_value = var.target_value_cpu
  }
}

resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = aws_alb.app_application_load_balancer.dns_name
    origin_id   = aws_alb.app_application_load_balancer.dns_name
    custom_origin_config {
      origin_protocol_policy = var.origin_protocol_policy
      http_port              = var.http_port
      https_port             = var.https_port
      origin_ssl_protocols   = var.origin_ssl_protocols
    }
  }
  enabled = var.enabled
  default_cache_behavior {
    allowed_methods            = var.allowed_methods
    cached_methods             = var.cached_methods
    target_origin_id           = aws_alb.app_application_load_balancer.dns_name
    cache_policy_id            = var.cache_policy_id
    origin_request_policy_id   = var.origin_request_policy_id
    response_headers_policy_id = var.response_headers_policy_id
    viewer_protocol_policy     = var.viewer_protocol_policy
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
