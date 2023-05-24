variable "region" {
  description = "AWS region where resources will be deployed"
  type    = string
  default = "us-west-1"
}

variable "aws_vpc_default" {
  type    = bool
  default = false
}

variable "vpc_id" {
  description = "VPC ID for launching clusters"
  type    = string
  default = ""
}

variable "reponame" {
  description = "Name of the ECR repository"
  type        = string
  default     = "kj-nodejs-eks-repo"
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE"
  type        = string
  default     = "IMMUTABLE"
}

variable "force_delete" {
  description = "If true, will delete the repository even if it contains images. Defaults to false"
  type        = bool
  default     = true
}

variable "egress_from_port" {
  description = "Start port (or ICMP type number if protocol is icmp or icmpv6)"
  type        = number
  default     = 0
}

variable "egress_to_port" {
  description = "End range port (or ICMP code if protocol is icmp"
  type        = number
  default     = 0
}

variable "egress_protocol" {
  description = "Protocol. If you select a protocol of -1 (semantically equivalent to all, which is not a valid value here), you must specify a from_port and to_port equal to 0"
  type        = string
  default     = "-1"
}

variable "egress_cidr_blocks" {
  description = "List of CIDR blocks"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "sg_from_port" {
  description = "Start port (or ICMP type number if protocol is 'icmp' or 'icmpv6')"
  type    = number
  default = 443
}

variable "sg_protocol" {
  description = "Protocol, if not icmp, icmpv6, tcp, udp, or all use the protocol number"
  type    = string
  default = "tcp"
}
variable "sg_to_port" {
  description = "End port (or ICMP code if protocol is 'icmp')"
  type    = number
  default = 443
}
variable "sg_type" {
  description = "Type of rule being created. Valid options are ingress (inbound) or egress (outbound)"
  type    = string
  default = "ingress"
}

variable "cluster_name" {
  description = "Name of the cluster. Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores '(^[0-9A-Za-z][A-Za-z0-9\\-_]+$)'"
  type    = string
  default = "K8_Cluster"
}

variable "node_group_name" {
  description = "Name of the EKS Node Group. If omitted, Terraform will assign a random, unique name. Conflicts with node_group_name_prefix"
  type    = string
  default = "k8_cluster"
}

variable "instance_type" {
  description = "List of instance types associated with the EKS Node Group. Defaults to ['t3.medium']. Terraform will only perform drift detection if a configuration value is provided"
  type    = string
  default = "t3.medium"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type    = number
  default = "1"
}

variable "max_capacity" {
  description = "Maximum number of worker node"
  type    = number
  default = "2"
}

variable "min_capacity" {
  description = "Minimum number of worker node"
  type    = number
  default = "1"
}

variable "lbControllerRoleName" {
  description = "Name of the IAM role for load balancer controller, if omitted, Terraform will assign a random, unique name"
  type = string
  default = "AmazonEKSLoadBalancerControllerRole"
}

variable "accid" {
  description = "AWS IAM Account ID"
  type = string
  default = ""
}

variable "oidc" {
  type = string
  default = ""
}

variable "loadBalancerControllerPolicy" {
  description = "Name of the IAM policy for load balancer controller, if omitted, Terraform will assign a random, unique name"
  type = string
  default = "AWSLoadBalancerControllerIAMPolicy"
}

variable "address" {
  type = string
  default = ""
}

variable "origin_protocol_policy" {
  description = "The origin protocol policy to apply to your origin. One of http-only, https-only, or match-viewer"
  type        = string
  default     = "http-only"
}

variable "http_port" {
  description = "The HTTP port the custom origin listens on"
  type        = string
  default     = "80"
}

variable "https_port" {
  description = "The HTTPS port the custom origin listens on"
  type        = string
  default     = "443"
}

variable "origin_ssl_protocols" {
  description = "The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS. A list of one or more of SSLv3, TLSv1, TLSv1.1, and TLSv1.2"
  type        = list(any)
  default     = ["TLSv1.2"]
}

variable "enabled" {
  description = "Whether the distribution is enabled to accept end user requests for content"
  type        = bool
  default     = true
}

variable "allowed_methods" {
  description = "Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin"
  type        = list(any)
  default     = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}

variable "cached_methods" {
  description = "Controls whether CloudFront caches the response to requests using the specified HTTP methods"
  type        = list(any)
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "viewer_protocol_policy" {
  description = "Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https"
  type        = string
  default     = "allow-all"
}

variable "query_string" {
  description = "Indicates whether you want CloudFront to forward query strings to the origin that is associated with this cache behavior"
  type = bool
  default = false
}

variable "forward" {
  description = "Whether you want CloudFront to forward cookies to the origin that is associated with this cache behavior. You can specify all, none or whitelist. If whitelist, you must include the subsequent whitelisted_names"
  type = string
  default = "none"
}

variable "restriction_type" {
  description = "The method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist"
  type        = string
  default     = "none"
}

variable "cloudfront_default_certificate" {
  description = "True if you want viewers to use HTTPS to request your objects and you're using the CloudFront domain name for your distribution. Specify this, acm_certificate_arn, or iam_certificate_id"
  type        = bool
  default     = true
}

variable "env" {
  description = "Environment for resource provisioning"
  type        = string
  default     = "dev"
}

variable "createdBy" {
  description = "Tag for each resource, reflects author name"
  type        = string
  default     = "KloudJet"
}

variable "project" {
  description = "Tag for each resource, reflects Project ID (Find your Project ID on the Kloudjet Portal, passing incorrect or null value will disturb the metrics)"
  type        = string
  default     = "PID123"
}

variable "projectComponent" {
  description = "Tag for each resource, reflects Component ID (Find your Project Component ID on the Kloudjet Portal, passing incorrect or null value will disturb the metrics)"
  type        = string
  default     = "CID123"
}