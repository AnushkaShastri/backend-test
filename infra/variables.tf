variable "region" {
  description = "AWS Region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "reponame" {
  description = "Name of the repository"
  type        = string
  default     = "kloudjet-spring-ec2-repo"
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

variable "clustername" {
  description = "Name of the cluster (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string
  default     = "kloudjet-spring-ec2-cluster"
}

variable "ecs_task_family" {
  description = "A unique name for your task definition"
  type        = string
  default     = "kloudjet_ecs_task"
}

variable "ecs_task_essential" {
  description = "If the essential parameter of a container is marked as true, and that container fails or stops for any reason, all other containers that are part of the task are stopped"
  type        = string
  default     = "true"
}

variable "requires_compatibilities" {
  description = "Set of launch types required by the ECS task. The valid values are EC2 and FARGATE"
  type        = list(any)
  default     = ["EC2"]
}

variable "network_mode" {
  description = "Docker networking mode to use for the containers in the ECS task. Valid values are none, bridge, awsvpc, and host"
  type        = string
  default     = "awsvpc"
}

variable "memory" {
  description = "Amount (in MiB) of memory used by the ECS task. If the requires_compatibilities is FARGATE this field is required"
  type        = number
  default     = 512
}

variable "cpu" {
  description = "Number of cpu units used by the ECS task. If the requires_compatibilities is FARGATE this field is required"
  type        = number
  default     = 256
}

variable "ecstaskrolename" {
  description = "Name of the ECS Task IAM Role. If omitted, Terraform will assign a random, unique name"
  type        = string
  default     = "kj_ecsTaskExecutionRole"
}

variable "servicename" {
  description = "Name of the service (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string
  default     = "kloudjet_app_service"
}

variable "launch_type" {
  description = "Launch type on which to run your ECS service. The valid values are EC2, FARGATE, and EXTERNAL. Defaults to EC2"
  type        = string
  default     = "EC2"
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running, in ECS service. Defaults to 0. Do not specify if using the DAEMON scheduling strategy"
  type        = number
  default     = 3
}

variable "container_port" {
  description = "Port on the container to associate with the load balancer"
  type        = number
  default     = 8080
}

variable "app_service_sg_ingress_from_port" {
  description = "Start port (or ICMP type number if protocol is icmp or icmpv6)"
  type        = number
  default     = 0
}

variable "app_service_sg_ingress_to_port" {
  description = "End range port (or ICMP code if protocol is icmp"
  type        = number
  default     = 0
}

variable "app_service_sg_ingress_protocol" {
  description = "Ingress Protocol, if you select a protocol of -1 (semantically equivalent to all, which is not a valid value here), you must specify a from_port and to_port equal to 0"
  type        = string
  default     = "-1"
}

variable "app_service_sg_egress_from_port" {
  description = "Start port (or ICMP type number if protocol is icmp)"
  type        = number
  default     = 0
}

variable "app_service_sg_egress_to_port" {
  description = "End range port (or ICMP code if protocol is icmp)"
  type        = number
  default     = 0
}

variable "app_service_sg_egress_protocol" {
  description = "Protocol. If you select a protocol of -1 (semantically equivalent to all, which is not a valid value here), you must specify a from_port and to_port equal to 0"
  type        = string
  default     = "-1"
}

variable "app_service_sg_egress_cidr_blocks" {
  description = "List of CIDR blocks"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "regiona" {
  description = "AWS default subnet availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "regionb" {
  description = "AWS default subnet availability zone"
  type        = string
  default     = "us-east-1b"
}

variable "regionc" {
  description = "AWS default subnet availability zone"
  type        = string
  default     = "us-east-1c"
}

variable "lbname" {
  description = "The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen. If not specified, Terraform will autogenerate a name beginning with tf-lb"
  type        = string
  default     = "spring-lb-ec2"
}

variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible values are application, gateway, or network. The default value is application"
  type        = string
  default     = "application"
}

variable "lb_sg_ingress_from_port" {
  description = "Start port (or ICMP type number if protocol is icmp or icmpv6)"
  type        = number
  default     = 8080
}

variable "lb_sg_ingress_to_port" {
  description = "End range port (or ICMP code if protocol is icmp"
  type        = number
  default     = 8080
}

variable "lb_sg_ingress_protocol" {
  description = "Protocol. If you select a protocol of -1 (semantically equivalent to all, which is not a valid value here), you must specify a from_port and to_port equal to 0"
  type        = string
  default     = "tcp"
}

variable "lb_sg_ingress_cidr_blocks" {
  description = "List of CIDR blocks"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "lb_sg_ingress_ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR blocks"
  type        = list(any)
  default     = ["::/0"]
}

variable "lb_sg_egress_from_port" {
  description = "Start port (or ICMP type number if protocol is icmp or icmpv6)"
  type        = number
  default     = 0
}

variable "lb_sg_egress_to_port" {
  description = "End range port (or ICMP code if protocol is icmp"
  type        = number
  default     = 0
}

variable "lb_sg_egress_protocol" {
  description = "Protocol. If you select a protocol of -1 (semantically equivalent to all, which is not a valid value here), you must specify a from_port and to_port equal to 0"
  type        = string
  default     = "-1"
}

variable "lb_sg_egress_cidr_blocks" {
  description = "List of CIDR blocks"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "lb_sg_egress_ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR blocks"
  type        = list(any)
  default     = ["::/0"]
}

variable "tgname" {
  description = "Name of the target group. If omitted, Terraform will assign a random, unique name"
  type        = string
  default     = "kloudjettargetgroup"
}

variable "lb_tg_port" {
  description = "Port on which targets receive traffic, unless overridden when registering a specific target. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda"
  type        = number
  default     = 8080
}

variable "lb_tg_protocol" {
  description = "Protocol to use for routing traffic to the targets. Should be one of GENEVE, HTTP, HTTPS, TCP, TCP_UDP, TLS, or UDP. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda"
  type        = string
  default     = "HTTP"
}

variable "target_type" {
  description = "Type of target that you must specify when registering targets with this target group"
  type        = string
  default     = "ip"
}

variable "matcher" {
  description = "Response codes to use when checking for a healthy responses from a target"
  type        = string
  default     = "200,301,302"
}

variable "path" {
  description = "Destination for the health check request. Required for HTTP/HTTPS ALB and HTTP NLB. Only applies to HTTP/HTTPS"
  type        = string
  default     = "/"
}

variable "healthy_threshold" {
  description = "Number of consecutive health check successes required before considering a target healthy. The range is 2-10. Defaults to 3"
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "Number of consecutive health check failures required before considering a target unhealthy. The range is 2-10. Defaults to 3"
  type        = number
  default     = 10
}

variable "timeout" {
  description = "Amount of time, in seconds, during which no response from a target means a failed health check. The range is 2–120 seconds"
  type        = number
  default     = 3
}

variable "interval" {
  description = "Approximate amount of time, in seconds, between health checks of an individual target. The range is 5-300"
  type        = number
  default     = 10
}

variable "lb_tg_health_protocol" {
  description = "Protocol the load balancer uses when performing health checks on targets. Must be either TCP, HTTP, or HTTPS. The TCP protocol is not supported for health checks if the protocol of the target group is HTTP or HTTPS. Defaults to HTTP"
  type        = string
  default     = "HTTP"
}

variable "image" {
  description = "AMI to use for the instance. Required unless launch_template is specified and the Launch Template specifes an AMI"
  type        = string
  default     = "ami-02e136e904f3da870"
}

variable "instance_type" {
  description = "Instance type to use for the instance. Updates to this field will trigger a stop/start of the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "ec2_role_name" {
  description = "Name of IAM role for EC2"
  type        = string
  default     = "nodejs_ecsTaskExecutionRole"
}

variable "ec2_profile_name" {
  description = "Name of IAM Instance Profile for EC2"
  type        = string
  default     = "nodejs_ecsTaskExecutionProfile"
}

variable "ec2_policy_name" {
  description = "Name of IAM Policy for EC2"
  type        = string
  default     = "nodejs_ecsTaskExecutionPolicy"
}

variable "lb_listener_port" {
  description = "Port on which the load balancer is listening. Not valid for Gateway Load Balancers"
  type        = string
  default     = "8080"
}

variable "lb_listener_protocol" {
  description = "Protocol for connections from clients to the load balancer"
  type        = string
  default     = "HTTP"
}

variable "lb_listener_type" {
  description = "Type of routing action. Valid values are forward, redirect, fixed-response, authenticate-cognito and authenticate-oidc"
  type        = string
  default     = "forward"
}

variable "max_capacity" {
  description = "Max capacity of the scalable target"
  type        = number
  default     = 4
}
variable "min_capacity" {
  description = "Min capacity of the scalable target"
  type        = number
  default     = 1
}

variable "scalable_dimension" {
  description = "Scalable dimension of the scalable target"
  type        = string
  default     = "ecs:service:DesiredCount"
}

variable "service_namespace" {
  description = "AWS service namespace of the scalable target"
  type        = string
  default     = "ecs"
}

variable "aspolicyname" {
  description = "Name of the policy. Must be between 1 and 255 characters in length"
  type        = string
  default     = "app_as_memory_autoscaling"
}

variable "policy_type_memory" {
  description = "Policy type for memory of Application AutoScaling Policy. Valid values are StepScaling and TargetTrackingScaling. Defaults to StepScaling"
  type        = string
  default     = "TargetTrackingScaling"
}

variable "predefined_metric_type_memory" {
  description = "Metric type for memory of Application AutoScaling Policy"
  type        = string
  default     = "ECSServiceAverageMemoryUtilization"
}

variable "target_value_memory" {
  description = "Target value for the memory metric"
  type        = number
  default     = 80
}

variable "appautoscaling_policy_name" {
  description = "Name of the policy. Must be between 1 and 255 characters in length"
  type        = string
  default     = "app_as_cpu_autoscaling"
}

variable "policy_type_cpu" {
  description = "Policy type for cpu of Application AutoScaling Policy. Valid values are StepScaling and TargetTrackingScaling. Defaults to StepScaling"
  type        = string
  default     = "TargetTrackingScaling"
}

variable "predefined_metric_type_cpu" {
  description = "Metric type for cpu of Application AutoScaling Policy"
  type        = string
  default     = "ECSServiceAverageCPUUtilization"
}

variable "target_value_cpu" {
  description = "Target value for cpu metric of Application AutoScaling Policy"
  type        = number
  default     = 60
}

variable "origin_protocol_policy" {
  description = "The origin protocol policy to apply to your origin. One of http-only, https-only, or match-viewer"
  type        = string
  default     = "http-only"
}

variable "http_port" {
  description = "The HTTP port the custom origin listens on"
  type        = string
  default     = "8080"
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

variable "cache_policy_id" {
  description = "The unique identifier of the cache policy that is attached to the cache behavior"
  type        = string
  default     = "658327ea-f89d-4fab-a63d-7e88639e58f6"
}

variable "origin_request_policy_id" {
  description = "The unique identifier of the origin request policy that is attached to the behavior"
  type        = string
  default     = "59781a5b-3903-41f3-afcb-af62929ccde1"
}

variable "response_headers_policy_id" {
  description = "The identifier for a response headers policy"
  type        = string
  default     = "60669652-455b-4ae9-85a4-c4c02393f86c"
}

variable "viewer_protocol_policy" {
  description = "Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https"
  type        = string
  default     = "allow-all"
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
