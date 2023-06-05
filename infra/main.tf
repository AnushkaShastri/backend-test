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

# terraform {
#   backend "http" {
#     update_method = "POST"
#     lock_method   = "POST"
#     unlock_method = "POST"
#   }
# }

locals {
  # vpc_id = var.aws_vpc_default ? null : var.vpc_id
  workstation-external-cidr        = "${chomp(data.http.workstation-external-ip.body)}/32"
  force_delete                     = var.force_delete == "null" ? null : var.force_delete
  image_tag_mutability             = var.image_tag_mutability == "null" ? null : var.image_tag_mutability
  iam_role_description             = var.iam_role_description == "null" ? null : var.iam_role_description
  force_detach_policies            = var.force_detach_policies == "null" ? null : var.force_detach_policies
  max_session_duration             = var.max_session_duration == "null" ? null : var.max_session_duration
  iam_path                         = var.iam_path == "null" ? null : var.iam_path
  iam_role_name                    = (var.iam_role_name == "null" || var.iam_role_name == null) ? null : "${var.env}-${var.iam_role_name}"
  iam_role_prefix                  = (var.iam_role_prefix == "null" || var.iam_role_prefix == null) ? null : "${var.env}-${var.iam_role_prefix}"
  sg_description                   = var.sg_description == "null" ? null : var.sg_description
  sg_name                          = (var.sg_name == "null" || var.sg_name == null) ? null : "${var.env}-${var.sg_name}"
  sg_name_prefix                   = (var.sg_name_prefix == "null" || var.sg_name_prefix == null) ? null : "${var.env}-${var.sg_name_prefix}"
  revoke_rules_on_delete           = var.revoke_rules_on_delete == "null" ? null : var.revoke_rules_on_delete
  version                          = var.cluster_version == "null" ? null : var.cluster_version
  eks_ami_type                     = var.eks_ami_type == "null" ? null : var.eks_ami_type
  capacity_type                    = var.capacity_type == "null" ? null : var.capacity_type
  disk_size                        = var.disk_size == "null" ? null : var.disk_size
  force_update_version             = var.force_update_version == "null" ? null : var.force_update_version
  node_group_version               = var.node_group_version == "null" ? null : var.node_group_version
  loadBalancerControllerPolicyPath = var.loadBalancerControllerPolicyPath == "null" ? null : var.loadBalancerControllerPolicyPath
  aliases                          = var.aliases == "null" ? null : var.aliases
  cloudfront_comments              = var.cloudfront_comments == "null" ? null : var.cloudfront_comments
  compress                         = var.compress == "null" ? null : var.compress
  default_ttl                      = var.default_ttl == "null" ? null : var.default_ttl
  field_level_encryption_id        = var.field_level_encryption_id == "null" ? null : var.field_level_encryption_id
  max_ttl                          = var.max_ttl == "null" ? null : var.max_ttl
  min_ttl                          = var.min_ttl == "null" ? null : var.min_ttl
  origin_request_policy_id         = var.origin_request_policy_id == "null" ? null : var.origin_request_policy_id
  realtime_log_config_arn          = var.realtime_log_config_arn == "null" ? null : var.realtime_log_config_arn
  response_headers_policy_id       = var.response_headers_policy_id == "null" ? null : var.response_headers_policy_id
  smooth_streaming                 = var.smooth_streaming == "null" ? null : var.smooth_streaming
  default_root_object              = var.default_root_object == "null" ? null : var.default_root_object
  enabled                          = var.enabled == "null" ? null : var.enabled
  is_ipv6_enabled                  = var.is_ipv6_enabled == "null" ? null : var.is_ipv6_enabled
  http_version                     = var.http_version == "null" ? null : var.http_version
  connection_attempts              = var.connection_attempts == "null" ? null : var.connection_attempts
  connection_timeout               = var.connection_timeout == "null" ? null : var.connection_timeout
  origin_keepalive_timeout         = var.origin_keepalive_timeout == "null" ? null : var.origin_keepalive_timeout
  origin_read_timeout              = var.origin_read_timeout == "null" ? null : var.origin_read_timeout
  origin_path         = var.origin_path == "null" ? null : var.origin_path
  price_class         = var.price_class == "null" ? null : var.price_class
  web_acl_id          = var.web_acl_id == "null" ? null : var.web_acl_id
  retain_on_delete    = var.retain_on_delete == "null" ? null : var.retain_on_delete
  wait_for_deployment = var.wait_for_deployment == "null" ? null : var.wait_for_deployment



  # sgr_description             = var.sgr_description == "null" ? null : var.sgr_description
  # encryption_config           = var.encryption_config == false ? [] : [{}]
  # service_ipv4_cidr           = var.service_ipv4_cidr == "null" ? null : var.service_ipv4_cidr
  # ip_family                   = var.ip_family == "null" ? null : var.ip_family
  # outpost_config              = var.outpost_config == false ? [] : [{}]
  # control_plane_instance_type = var.control_plane_instance_type == "null" ? null : var.control_plane_instance_type
  # group_name                  = var.group_name == "null" ? null : var.group_name
  # launch_template             = var.launch_template == false ? [] : [{}]
  # launch_template_id          = var.launch_template_id == "null" ? null : var.launch_template_id
  # launch_template_name        = var.launch_template_name == "null" ? null : var.launch_template_name
  # launch_template_version     = var.launch_template_version == "null" ? null : var.launch_template_version
  # node_group_name             = (var.node_group_name == "null" || var.node_group_name == null) ? null : "${var.env}-${var.node_group_name}"
  # node_group_name_prefix      = (var.node_group_name_prefix == "null" || var.node_group_name_prefix == null) ? null : "${var.env}-${var.node_group_name_prefix}"
  # release_version             = var.release_version == "null" ? null : var.release_version
  # ec2_ssh_key                 = var.ec2_ssh_key == "null" ? null : var.ec2_ssh_key
  # default_ttl                 = var.default_ttl == "null" ? null : var.default_ttl
  # field_level_encryption_id   = var.field_level_encryption_id == "null" ? null : var.field_level_encryption_id
  # # whitelisted_names = var.whitelisted_names == "null" ? null : var.whitelisted_names


  # origin_shield            = var.origin_shield == false ? [] : [{}]
  # origin_shield_region     = var.origin_shield_region == "null" ? null : var.origin_shield_region
  # acm_certificate_arn      = var.acm_certificate_arn == "null" ? null : var.acm_certificate_arn
  # iam_certificate_id       = var.iam_certificate_id == "null" ? null : var.iam_certificate_id
  # minimum_protocol_version = var.minimum_protocol_version == "null" ? null : var.minimum_protocol_version
  # ssl_support_method       = var.ssl_support_method == "null" ? null : var.ssl_support_method

}

##############################################################

# Data sources to get VPC, subnets and security group details

##############################################################

# data "aws_vpc" "vpc" {
#   default = false
#   id = var.vpc_id
# }

data "aws_subnets" "all" {
  filter {
    name = "vpc-id"
    # values = [data.aws_vpc.vpc.id]
    values = var.vpc_id
  }
}

data "tls_certificate" "cluster" {
  depends_on = [
    aws_eks_cluster.k8_cluster
  ]
  url = aws_eks_cluster.k8_cluster.identity.0.oidc.0.issuer
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_ecr_repository" "app_container_ecr_repo" {
  name = "${var.env}-${var.reponame}"
  dynamic "encryption_configuration" {
    for_each = length(var.encryption_configuration) == 0 ? [] : [var.encryption_configuration]
    content {
      encryption_type = lookup(encryption_configuration.value, "ecr_encryption_type", null)
      kms_key         = lookup(encryption_configuration.value, "ecr_kms_key", null)
    }
  }
  force_delete         = local.force_delete
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

# EKS CLUSTER Resources :
# EKS cluster
# IAM Role to allow EKS service to manage other AWS services
# EC2 SG to allow networking traffic with EKS cluster

resource "aws_iam_role" "k8_cluster" {
  description           = local.iam_role_description
  force_detach_policies = local.force_detach_policies
  max_session_duration  = local.max_session_duration
  path                  = local.iam_path
  name                  = local.iam_role_name
  name_prefix           = local.iam_role_prefix
  tags                  = var.iam_role_tags
  assume_role_policy    = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "eks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
POLICY
}

resource "aws_iam_role_policy_attachment" "k8_cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.k8_cluster.name
}

resource "aws_iam_role_policy_attachment" "k8_cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.k8_cluster.name
}

resource "aws_security_group" "k8_cluster" {
  description = local.sg_description
  dynamic "egress" {
    for_each = var.sg_egress
    content {
      from_port        = egress.value.sg_egress_from_port
      to_port          = egress.value.sg_egress_to_port
      cidr_blocks      = egress.value.sg_egress_cidr_blocks
      protocol         = egress.value.sg_egress_protocol
      description      = lookup(egress.value, "sg_egress_description", null)
      ipv6_cidr_blocks = lookup(egress.value, "sg_egress_ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(egress.value, "sg_egress_prefix_list_ids", null)
      security_groups  = lookup(egress.value, "sg_egress_security_groups", null)
      self             = lookup(egress.value, "sg_egress_self", null)
    }
  }
  dynamic "ingress" {
    for_each = var.sg_ingress
    content {
      from_port        = lookup(ingress.value, "sg_ingress_from_port", null)
      to_port          = lookup(ingress.value, "sg_ingress_to_port", null)
      protocol         = lookup(ingress.value, "sg_ingress_protocol", null)
      cidr_blocks      = lookup(ingress.value, "sg_ingress_cidr_blocks", null)
      description      = lookup(ingress.value, "sg_ingress_description", null)
      ipv6_cidr_blocks = lookup(ingress.value, "sg_ingress_ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(ingress.value, "sg_ingress_prefix_list_ids", null)
      security_groups  = lookup(ingress.value, "sg_ingress_security_groups", null)
      self             = lookup(ingress.value, "sg_ingress_self", null)
    }
  }
  name_prefix            = local.sg_name_prefix
  name                   = local.sg_name
  revoke_rules_on_delete = local.revoke_rules_on_delete
  tags                   = var.sg_tags
  vpc_id                 = var.vpc_id
}

resource "aws_security_group_rule" "k8_cluster-ingress-workstation-https" {
  from_port         = var.sg_from_port
  protocol          = var.sg_protocol
  security_group_id = aws_security_group.k8_cluster.id
  to_port           = var.sg_to_port
  type              = "ingress"
  cidr_blocks       = [local.workstation-external-cidr]
  description       = local.sgr_description
  ipv6_cidr_blocks  = var.ipv6_cidr_blocks
  prefix_list_ids   = var.sgr_prefix_list_ids
}

resource "aws_eks_cluster" "k8_cluster" {
  name     = "${var.env}_${var.cluster_name}"
  role_arn = aws_iam_role.k8_cluster.arn
  vpc_config {
    security_group_ids      = [aws_security_group.k8_cluster.id]
    subnet_ids              = data.aws_subnets.all.ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }
  enabled_cluster_log_types = var.enabled_cluster_log_types
  dynamic "encryption_config" {
    for_each = length(var.eks_cluster_encryption_config) == 0 ? [] : [var.eks_cluster_encryption_config]
    content {
      provider {
        key_arn = lookup(encryption_config.value, "key_arn", null)
      }
      resources = lookup(encryption_config.value, "resources", null)
    }
  }
  dynamic "kubernetes_network_config" {
    for_each = length(var.kubernetes_network_config) == 0 ? [] : [var.kubernetes_network_config]
    content {
      service_ipv4_cidr = lookup(kubernetes_network_config.value, "service_ipv4_cidr", null)
      ip_family         = lookup(kubernetes_network_config.value, "ip_family", null)
    }
  }
  dynamic "outpost_config" {
    for_each = length(var.outpost_config) == 0 ? [] : [var.outpost_config]
    content {
      control_plane_instance_type = outpost_config.value.control_plane_instance_type
      control_plane_placement {
        group_name = outpost_config.value.control_plane_group_name
      }
      outpost_arns = outpost_config.value.outpost_arns
    }
  }
  tags    = var.cluster_tags
  version = local.cluster_version
  depends_on = [
    aws_iam_role_policy_attachment.k8_cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.k8_cluster-AmazonEKSVPCResourceController,
  ]
}

resource "aws_iam_openid_connect_provider" "cluster" {
  depends_on = [
    aws_eks_cluster.k8_cluster
  ]
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.k8_cluster.identity.0.oidc.0.issuer
  tags            = var.oidc_tags
}

# EKS Worker nodes Resource:
# IAM role allowing k8 actions to access other aws services
# EKS Node group to launch worker nodes

resource "aws_iam_role" "k8_cluster-node" {
  assume_role_policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                },

                "Action": "sts:AssumeRole"
            }
        ]

    }
POLICY
}

resource "aws_iam_role_policy_attachment" "k8_cluster-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.k8_cluster-node.name
}

resource "aws_iam_role_policy_attachment" "k8_cluster-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.k8_cluster-node.name
}

resource "aws_iam_role_policy_attachment" "k8_cluster-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.k8_cluster-node.name
}

resource "aws_eks_node_group" "k8_cluster" {
  cluster_name  = aws_eks_cluster.k8_cluster.name
  node_role_arn = aws_iam_role.k8_cluster-node.arn
  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }
  subnet_ids           = data.aws_subnets.all.ids
  ami_type             = local.eks_ami_type
  capacity_type        = local.capacity_type
  disk_size            = local.disk_size
  force_update_version = local.force_update_version
  instance_types       = var.instance_types
  labels               = var.labels
  dynamic "launch_template" {
    for_each = length(var.launch_template) == 0 ? [] : [var.launch_template]
    content {
      id      = lookup(launch_template.value, "launch_template_id", null)
      name    = lookup(launch_template.value, "launch_template_name", null)
      version = lookup(launch_template.value, "launch_template_version", null)
    }
  }
  node_group_name        = local.node_group_name
  node_group_name_prefix = local.node_group_name_prefix
  release_version        = local.release_version
  dynamic "remote_access" {
    for_each = length(var.remote_access) == 0 ? [] : [var.remote_access]
    content {
      ec2_ssh_key               = lookup(remote_access.value, "ec2_ssh_key", null)
      source_security_group_ids = lookup(remote_access.value, "source_security_group_ids", null)
    }
  }
  tags = var.node_group_tags
  dynamic "taint" {
    for_each = var.taint
    content {
      key    = lookup(taint.value, "taint_key", null)
      value  = lookup(taint.value, "taint_value", null)
      effect = lookup(taint.value, "taint_effect", null)
    }
  }
  version = local.node_group_version
  depends_on = [
    aws_iam_role_policy_attachment.k8_cluster-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.k8_cluster-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.k8_cluster-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "AmazonEKSLoadBalancerControllerRole" {
  name               = "${var.env}-${var.lbControllerRoleName}"
  assume_role_policy = data.aws_iam_policy_document.AmazonEKSLoadBalancerControllerRole_policy.json
}

data "aws_iam_policy_document" "AmazonEKSLoadBalancerControllerRole_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${var.accid}:oidc-provider/${var.oidc}"]
    }
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "${var.oidc}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "${var.oidc}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_policy" "load_balancer_controller" {
  name   = "${var.env}_${var.loadBalancerControllerPolicy}"
  path   = local.loadBalancerControllerPolicyPath
  policy = file("loadBalancerController.json")
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.AmazonEKSLoadBalancerControllerRole.name
  policy_arn = aws_iam_policy.load_balancer_controller.arn
}

resource "aws_cloudfront_distribution" "distribution" {
  aliases = local.aliases
  comment = local.cloudfront_comments
  dynamic "custom_error_response" {
    for_each = var.custom_error_response
    content {
      error_caching_min_ttl = lookup(custom_error_response.value, "error_caching_min_ttl", null)
      error_code            = lookup(custom_error_response.value, "error_code", null)
      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
    }
  }
  default_cache_behavior {
    allowed_methods           = var.allowed_methods
    cached_methods            = var.cached_methods
    compress                  = local.compress
    default_ttl               = local.default_ttl
    field_level_encryption_id = local.field_level_encryption_id
    dynamic "forwarded_values" {
      for_each = length(var.forwarded_values) == 0 ? [] : [var.forwarded_values]
      content {
        cookies {
          forward           = lookup(forwarded_values.value, "forward", null)
          whitelisted_names = lookup(forwarded_values.value, "whitelisted_names", null)
        }
        headers      = lookup(forwarded_values.value, "forward_headers", null)
        query_string = lookup(forwarded_values.value, "query_string", null)
      }
      # query_string_cache_keys = lookup(default_cache_behavior.value, "query_string_cache_keys ", null)
    }

    dynamic "lambda_function_association" {
      for_each = var.lambda_function_association
      content {
        event_type   = lookup(lambda_function_association.value, "lambda_event_type", null)
        lambda_arn   = lookup(lambda_function_association.value, "lambda_arn", null)
        include_body = lookup(lambda_function_association.value, "include_body", null)
      }
    }
    dynamic "function_association" {
      for_each = var.function_association
      content {
        event_type   = lookup(function_association.value, "event_type", null)
        function_arn = lookup(function_association.value, "function_arn", null)
      }
    }
    max_ttl                    = local.max_ttl
    min_ttl                    = local.min_ttl
    origin_request_policy_id   = local.origin_request_policy_id
    realtime_log_config_arn    = local.realtime_log_config_arn
    response_headers_policy_id = local.response_headers_policy_id
    smooth_streaming           = local.smooth_streaming
    target_origin_id           = var.address
    trusted_key_groups         = var.trusted_key_groups
    trusted_signers            = var.trusted_signers
    viewer_protocol_policy     = var.viewer_protocol_policy

  }
  default_root_object = local.default_root_object
  enabled             = local.enabled
  is_ipv6_enabled     = local.is_ipv6_enabled
  http_version        = local.http_version
  dynamic "logging_config" {
    for_each = length(var.logging_config) == 0 ? [] : [var.logging_config]
    content {
      bucket          = lookup(logging_config.value, "log_bucket", null)
      include_cookies = lookup(logging_config.value, "log_include_cookies", null)
      prefix          = lookup(logging_config.value, "log_prefix", null)
    }
  }
  origin {
    connection_attempts = local.connection_attempts
    connection_timeout  = local.connection_timeout
    domain_name         = var.address
    origin_id           = var.address
    dynamic "custom_origin_config" {
      for_each = var.custom_origin_config
      content {
        http_port                = custom_origin_config.value.http_port
        https_port               = custom_origin_config.value.https_port
        origin_protocol_policy   = custom_origin_config.value.origin_protocol_policy
        origin_ssl_protocols     = custom_origin_config.value.origin_ssl_protocols
        origin_keepalive_timeout = lookup(custom_origin_config.value, "origin_keepalive_timeout", null)
        origin_read_timeout      = lookup(custom_origin_config.value, "origin_read_timeout", null)
      }
    }
    dynamic "custom_header" {
      for_each = var.custom_header
      content {
        name  = lookup(custom_header.value, "header_name", null)
        value = lookup(custom_header.value, "header_value", null)
      }
    }
    origin_path = local.origin_path
    dynamic "origin_shield" {
      for_each = length(var.origin_shield) == 0 ? [] : [var.origin_shield]
      content {
        enabled              = lookup(origin_shield.value, "origin_shield_enabled", null)
        origin_shield_region = lookup(origin_shield.value, "origin_shield_region", null)
      }
    }
  }
  price_class = local.price_class
  dynamic "restrictions" {
    for_each = var.restrictions
    content {
      geo_restriction {
        locations        = lookup(restrictions.value, "locations", null)
        restriction_type = restrictions.value.restriction_type
      }
    }
  }
  tags = var.cloudfront_tags
  dynamic "viewer_certificate" {
    for_each = length(var.viewer_certificate) == 0 ? [] : [var.viewer_certificate]
    content {
      cloudfront_default_certificate = lookup(viewer_certificate.value, "cloudfront_default_certificate", null)
      minimum_protocol_version       = lookup(viewer_certificate.value, "minimum_protocol_version", null)
      ssl_support_method             = lookup(viewer_certificate.value, "ssl_support_method", null)
    }
  }
  web_acl_id          = local.web_acl_id
  retain_on_delete    = local.retain_on_delete
  wait_for_deployment = local.wait_for_deployment
}
