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

variable "env" {
  description = "Environment for resource provisioning"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region where resources will be deployed"
  type    = string
  default = "us-west-1"
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

variable "encryption_configuration" {
  description = "Encryption configuration for the repository"
  type = list
  default = []
}

variable "force_delete" {
  description = "If true, will delete the repository even if it contains images. Defaults to false"
  type        = bool
  default     = true
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE"
  type        = string
  default     = "IMMUTABLE"
}

variable "image_scanning_configuration" {
  description = "Configuration block that defines image scanning configuration for the repository"
  type = list
  default = []
}

variable "ecr_tags" {
  description = "Map of tags for ecr repository"
  type = map
  default = {}
}

variable "iam_role_description" {
  description = "Description of the IAM Role" 
  type = string
  default = null 
}

variable "force_detach_policies" {
  description = "Whether to force detaching any policies the role has before destroying it"
  type = bool
  default = true
}

variable "max_session_duration" {
  description = "Maximum session duration (in seconds) that you want to set for the specified role, if you do not specify a value for this setting, the default maximum of one hour is applied, this setting can have a value from 1 hour to 12 hours"
  type = string
  default = 3600
}

variable "iam_path" {
  description = "Path to the role"
  type = string
  default = "/"
}

variable "iam_role_name" {
  description = "Name of the IAM role, if omitted, Terraform will assign a random, unique name"
  type        = string
  default     = "kloudjet-nodejs-app-iam-role"
}

variable "iam_role_prefix" {
  description = "Creates a unique friendly name beginning with the specified prefix, conflicts with name"
  type = string
  default = null
}

variable "iam_role_tags" {
  description = "Key-value mapping of tags for the IAM role"
  type = map
  default = {}
}

variable "sg_description" {
  description = "Security group description, defaults to Managed by Terraform, cannot be \"\" "
  type = string
  default = null
}

variable "sg_egress" {
  description = "Configuration block for egress rules"
  type = list
  default = [{"sg_egress_from_port":0, "sg_egress_to_port":0,"sg_egress_protocol":"-1", "sg_egress_cidr_blocks":["0.0.0.0/0"]}]
}

variable "sg_ingress" {
  description = "Configuration block for ingress rules"
  type = list
  default = [] 
}

variable "sg_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix, conflicts with name"
  type = string
  default = null
}

variable "sg_name" {
  description = "Name of the security group, if omitted, Terraform will assign a random, unique name"
  type = string
  default = null
}

variable "revoke_rules_on_delete" {
  description = "Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself"
  type = bool
  default = false
}

variable "sg_tags" {
  description = "Map of tags to assign to the security group"
  type = map
  default = {}
}

variable "sg_from_port" {
  description = "Start port (or ICMP type number if protocol is 'icmp' or 'icmpv6')"
  type    = string
  default = 443
}

variable "sg_protocol" {
  description = "Protocol, if not icmp, icmpv6, tcp, udp, or all use the protocol number"
  type    = string
  default = "tcp"
}

variable "sg_to_port" {
  description = "End port (or ICMP code if protocol is 'icmp')"
  type    = string
  default = 443
}

variable "sgr_description" {
  description = "Description of the security group rule"
  type = string
  default = null
}

variable "ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR blocks"
  type = list
  default = []
}

variable "sgr_prefix_list_ids" {
  description = "List of Prefix List IDs"
  type = list
  default = []
}

variable "cluster_name" {
  description = "Name of the cluster, must be between 1-100 characters in length, must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores '(^[0-9A-Za-z][A-Za-z0-9\\-_]+$)'"
  type    = string
  default = "K8_Cluster_nodejs"
}

variable "endpoint_private_access"{
  description = "Whether the Amazon EKS private API server endpoint is enabled"
  type = bool
  default = false
}

variable "endpoint_public_access"{
  description = "Whether the Amazon EKS public API server endpoint is enabled"
  type = bool
  default = true
}

variable "public_access_cidrs"{
  description = "List of CIDR blocks, indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled, EKS defaults this to a list with 0.0.0.0/0, Terraform will only perform drift detection of its value when present in a configuration"
  type = list
  default = ["0.0.0.0/0"] 
}

variable "enabled_cluster_log_types" {
  description = "List of the desired control plane logging to enable"
  type = list
  default = []
}

variable "eks_cluster_encryption_config" {
  description = "Configuration block with encryption configuration for the cluster"
  type = list
  default = []
}

variable "kubernetes_network_config" {
  description = "Configuration block with kubernetes network configuration for the cluster"
  type = list
  default = []  
}

variable "outpost_config" {
  description = "Configuration block representing the configuration of your local Amazon EKS cluster on an AWS Outpost"
  type = list
  default = []   
}

variable "cluster_tags" {
  description = "Key-value map of EKS Cluster resource tags"
  type = map
  default = {}
}

variable "cluster_version" {
  description = "Desired Kubernetes master version, if you do not specify a value, the latest available version at resource creation is used and no upgrades will occur except those automatically triggered by EKS, the value must be configured and increased to upgrade the version when desired, downgrades are not supported by EKS"
  type = string
  default = null
}

variable "oidc_tags" {
  description = "Map of resource tags for the IAM OIDC provider"
  type = map
  default = {}
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type    = string
  default = "1"
}

variable "max_capacity" {
  description = "Maximum number of worker node"
  type    = string
  default = "2"
}

variable "min_capacity" {
  description = "Minimum number of worker node"
  type    = string
  default = "1"
}

variable "eks_ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
  type = string
  default = null
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group, valid values: ON_DEMAND, SPOT, Terraform will only perform drift detection if a configuration value is provided"
  type = string
  default = null
}

variable "disk_size" {
  description = "Disk size in GiB for worker nodes. Defaults to 50 for Windows, 20 all other node groups"
  type = string
  default = null
}

variable "force_update_version" {
  description = "Force version update if existing pods are unable to be drained due to a pod disruption budget issue"
  type = string
  default = null
}

variable "instance_types" {
  description = "List of instance types associated with the EKS Node Group. Defaults to ['t3.medium']. Terraform will only perform drift detection if a configuration value is provided"
  type    = list
  default = ["t3.medium"]
}

variable "labels" {
  description = "Key-value map of Kubernetes labels, only labels that are applied with the EKS API are managed by this argument, other Kubernetes labels applied to the EKS Node Group will not be managed"
  type = map
  default = {}
}

variable "launch_template" {
  description = "Configuration block with Launch Template settings"
  type = list
  default = []
}

variable "node_group_name" {
  description = "Name of the EKS Node Group. If omitted, Terraform will assign a random, unique name. Conflicts with node_group_name_prefix"
  type    = string
  default = "k8_cluster_nodejs"
}

variable "node_group_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type    = string
  default = null
}

variable "release_version" {
  description = "AMI version of the EKS Node Group"
  type = string
  default = null
}

variable "remote_access" {
  description = "Configuration block with remote access settings"
  type = list
  default = []
}

variable "node_group_tags" {
  description = "Key-value map of EKS Node Group resource tags"
  type = map
  default = {}
}

variable "taint" {
  description = "The Kubernetes taints to be applied to the nodes in the node group, maximum of 50 taints per node group"
  type = list
  default = []
}

variable "node_group_version" {
  description = "Kubernetes version, defaults to EKS Cluster Kubernetes version"
  type = string
  default = null
}

variable "lbControllerRoleName" {
  description = "Name of the IAM role for load balancer controller, if omitted, Terraform will assign a random, unique name"
  type = string
  default = "nodejsEKSLoadBalancerControllerRole"
}

variable "accid" {
  description = "AWS IAM Account ID"
  type = string
  default = ""
}

variable "oidc" {
  description = "Open ID Connect Provider"
  type = string
  default = ""
}

variable "loadBalancerControllerPolicy" {
  description = "Name of the IAM policy for load balancer controller, if omitted, Terraform will assign a random, unique name"
  type = string
  default = "nodejsLoadBalancerControllerIAMPolicy"
}

variable "loadBalancerControllerPolicyPath" {
  description = "Path in which to create the Load Balancer Controller policy"
  type = string
  default = "/"
}

variable "aliases" {
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution"
  type = list
  default = []
}

variable "cloudfront_comments" {
  description = "Any comments you want to include about the distribution"
  type = string
  default = null
}

variable "custom_error_response" {
  description = "One or more custom error response elements (multiples allowed)"
  type = list
  default = []
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

variable "compress" {
  description = "Whether you want CloudFront to automatically compress content for web requests that include Accept-Encoding: gzip in the request header (default: false)"
  type = bool
  default = false
}

variable "default_ttl" {
  description = "The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header"
  type        = string
  default     = null
}

variable "field_level_encryption_id" {
  description = "Field level encryption configuration ID"
  type = string
  default = null
}

variable "forwarded_values" {
  description = "The forwarded values configuration that specifies how CloudFront handles query strings, cookies and headers"
  type = list
  default = [{"forward":"none","query_string":false}]
}

variable "lambda_function_association" {
  description = "Allows you to associate an AWS Lambda Function with a predefined event, you can associate a single function per event type, a config block that triggers a lambda function with specific actions (maximum 4)"
  type = list
  default = []
}

variable "function_association" {
  description = "Triggers a cloudfront function with specific actions (maximum 2)"
  type = list
  default = []
}

variable "max_ttl" {
  description = "The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. Only effective in the presence of Cache-Control max-age, Cache-Control s-maxage, and Expires headers"
  type        = string
  default     = null
}

variable "min_ttl" {
  description = "The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. Defaults to 0 seconds"
  type        = string
  default     = null
}

variable "origin_request_policy_id" {
  description = "Unique identifier of the origin request policy that is attached to the behavior"
  type = string
  default = null
}

variable "realtime_log_config_arn" {
  description = "ARN of the real-time log configuration that is attached to this cache behavior"
  type = string
  default = null
}

variable "response_headers_policy_id" {
  description = "Identifier for a response headers policy"
  type = string
  default = null
}

variable "smooth_streaming" {
  description = "Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior"
  type = bool
  default = false
}

variable "address" {
  type = string
  default = ""
}

variable "trusted_key_groups" {
  description = "List of key group IDs that CloudFront can use to validate signed URLs or signed cookies"
  type = list
  default = []
}

variable "trusted_signers" {
  description = "List of AWS account IDs (or self) that you want to allow to create signed URLs for private content"
  type = list
  default = []
}

variable "viewer_protocol_policy" {
  description = "Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https"
  type        = string
  default     = "allow-all"
}

variable "default_root_object" {
  description = "Object that you want CloudFront to return (for example, index.html) when an end user requests the root URL"
  type = string
  default = null
}

variable "enabled" {
  description = "Whether the distribution is enabled to accept end user requests for content"
  type        = bool
  default     = true
}

variable "is_ipv6_enabled" {
  description = "Whether the IPv6 is enabled for the distribution"
  type = bool
  default = false
}

variable "http_version" {
  description = "Maximum HTTP version to support on the distribution, allowed values are http1.1, http2, http2and3 and http3, the default is http2"
  type = string
  default = null
}

variable "logging_config" {
  description = "The logging configuration that controls how logs are written to your distribution"
  type = list
  default = []
}

variable "connection_attempts" {
  description = "Number of times that CloudFront attempts to connect to the origin, must be between 1-3, defaults to 3"
  type = string
  default = null
}

variable "connection_timeout" {
  description = "Number of seconds that CloudFront waits when trying to establish a connection to the origin, must be between 1-10, defaults to 10"
  type = string
  default = null
}

variable "custom_origin_config" {
  description = "The CloudFront custom origin configuration information"
  type = list
  default = [{"http_port":"80","https_port":"443","origin_protocol_policy":"http-only","origin_ssl_protocols":["TLSv1.2"]}]
}

variable "custom_header" {
  description = "One or more sub-resources with name and value parameters that specify header data that will be sent to the origin (multiples allowed)"
  type = list
  default = []
}

variable "origin_path" {
  description = "Optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin"
  type = string
  default = null
}

variable "origin_shield" {
  description = "The CloudFront Origin Shield configuration information"
  type = list
  default = []
}

variable "price_class" {
  description = "Price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
  type = string
  default = null
}

variable "restrictions" {
  description = "The restriction configuration for this distribution"
  type = list
  default = [{"restriction_type":"none"}]
}

variable "cloudfront_tags" {
  description = "A map of tags to assign to the CloudFront resource"
  type = map
  default = {}
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution"
  type = list
  default = [{"cloudfront_default_certificate":true}]
}

variable "web_acl_id" {
  description = "Unique identifier that specifies the AWS WAF web ACL, if any, to associate with this distribution"
  type = string
  default = null
}

variable "retain_on_delete" {
  description = "Disables the distribution instead of deleting it when destroying the resource through Terraform, if this is set, the distribution needs to be deleted manually afterwards"
  type = bool
  default = false
}

variable "wait_for_deployment" {
  description = "If enabled, the resource will wait for the distribution status to change from InProgress to Deployed"
  type = bool
  default = false
}