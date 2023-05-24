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
  vpc_id = var.aws_vpc_default ? null : var.vpc_id
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}

##############################################################

# Data sources to get VPC, subnets and security group details

##############################################################

data "aws_vpc" "default" {
  default = var.aws_vpc_default
  id = local.vpc_id
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
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

# EKS CLUSTER Resources :
# EKS cluster
# IAM Role to allow EKS service to manage other AWS services
# EC2 SG to allow networking traffic with EKS cluster

resource "aws_iam_role" "k8_cluster" {
  assume_role_policy = <<POLICY
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
  description = "Cluster communication with worker nodes"
  vpc_id      = data.aws_vpc.default.id
  egress {
    from_port   = var.egress_from_port
    to_port     = var.egress_to_port
    protocol    = var.egress_protocol
    cidr_blocks = var.egress_cidr_blocks
  }
}

resource "aws_security_group_rule" "k8_cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with cluster API Server"
  from_port         = var.sg_from_port
  protocol          = var.sg_protocol
  security_group_id = aws_security_group.k8_cluster.id
  to_port           = var.sg_to_port
  type              = var.sg_type
}

resource "aws_eks_cluster" "k8_cluster" {
  name     = "${var.env}_${var.cluster_name}"
  role_arn = aws_iam_role.k8_cluster.arn
  vpc_config {
    security_group_ids = [aws_security_group.k8_cluster.id]
    subnet_ids         = data.aws_subnets.all.ids
  }
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
  cluster_name    = aws_eks_cluster.k8_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.k8_cluster-node.arn
  subnet_ids      = data.aws_subnets.all.ids
  instance_types  = [var.instance_type]
  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }
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
  name        = "${var.env}_${var.loadBalancerControllerPolicy}"
  path        = "/"
  policy = file("loadBalancerController.json")
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.AmazonEKSLoadBalancerControllerRole.name
  policy_arn = aws_iam_policy.load_balancer_controller.arn
}

resource "aws_cloudfront_distribution" "distribution" {
 origin {
    domain_name = "${var.address}"
    origin_id   = "${var.address}"
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
    target_origin_id           = "${var.address}"
    viewer_protocol_policy     = var.viewer_protocol_policy
    forwarded_values {
            query_string = var.query_string
            cookies {
                forward = var.forward
            }
        }
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