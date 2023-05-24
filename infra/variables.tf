variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region where resources will be deployed"
}

variable "createdBy" {
  type        = string
  default     = "KloudJet"
  description = "Tag for each resource, reflects author name"
}

variable "project" {
  type        = string
  default     = "PID123"
  description = "Tag for each resource, reflects Project ID (Find your Project ID on the Kloudjet Portal, passing incorrect or null value will disturb the metrics)"
}

variable "projectComponent" {
  type        = string
  default     = "CID123"
  description = "Tag for each resource, reflects Component ID (Find your Project Component ID on the Kloudjet Portal, passing incorrect or null value will disturb the metrics)"
}

variable "env" {
  type        = string
  default     = "dev"
  description = "Environment for resource provisioning"
}

# variable "iam_policy_description" {
#   type = string
#   default = null
#   description = "Description of the IAM policy"
# }

variable "iam_policy_name" {
  type        = string
  default     = "kloudjet-node-app-iam-policy"
  description = "The name of the IAM role policy, if omitted, Terraform will assign a random, unique name"
}

variable "iam_policy_prefix" {
  type = string
  default = null
  description = "Creates a unique name beginning with the specified prefix, conflicts with name"
}

# variable "iam_policy_path" {
#   type = string
#   default = "/"
#   description = "Path in which to create the policy"
# }

# variable "iam_policy_tags" {
#   type = map
#   default = {}
#   description = "Map of resource tags for the IAM Policy"
# }

variable "iam_role_description" {
  type = string
  default = null
  description = "Description of the IAM Role"  
}

variable "iam_role_name" {
  type        = string
  default     = "kloudjet-node-app-iam-role"
  description = "Name of the IAM role. If omitted, Terraform will assign a random, unique name"
}

variable "force_detach_policies" {
  type = bool
  default = true
  description = "Whether to force detaching any policies the role has before destroying it"
}

variable "inline_policy" {
  type = list(map(string))
  default = null
  description = "Configuration block defining an exclusive set of IAM inline policies associated with the IAM role"
}

variable "managed_policy_arns" {
  type = list
  default = null
  description = "Set of exclusive IAM managed policy ARNs to attach to the IAM role, if this attribute is not configured, Terraform will ignore policy attachments to this resource, when configured, Terraform will align the role's managed policy attachments with this set by attaching or detaching managed policies, configuring an empty set (i.e., managed_policy_arns = []) will cause Terraform to remove all managed policy attachments"
}

variable "max_session_duration" {
  type = number
  default = 3600
  description = "Maximum session duration (in seconds) that you want to set for the specified role, if you do not specify a value for this setting, the default maximum of one hour is applied, this setting can have a value from 1 hour to 12 hours"
}

variable "iam_role_prefix" {
  type = string
  default = null
  description = "Creates a unique friendly name beginning with the specified prefix, conflicts with name"
}

variable "iam_role_path" {
  type = string
  default = null
  description = "Path to the role"
}

variable "permissions_boundary" {
  type = string
  default = null
  description = "ARN of the policy that is used to set the permissions boundary for the role"  
}

variable "iam_role_tags" {
  type = map
  default = {}
  description = "Key-value mapping of tags for the IAM role"
}

variable "reponame" {
  type        = string
  default     = "kloudjet-node-app-repo"
  description = "Name of the ECR repository"
}

variable "encryption_type" {
  type = string
  default = null
  description = "The encryption type to use for the repository"
}

variable "kms_key" {
  type = string
  default = null
  description = "The ARN of the KMS key to use when encryption_type is KMS, if not specified, uses the default AWS managed key for ECR"  
}

variable "force_delete" {
  type = bool
  default = true
  description = "Delete ECR repository if it contains"
}

variable "image_tag_mutability" {
  type        = string
  default     = "IMMUTABLE"
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE"
}

variable "scan_on_push" {
  type = bool
  default = false
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)"
}

variable "ecr_tags" {
  type = map
  default = {}
  description = "A map of tags to assign to the ECR resource"
}

variable "apprunner_service_name" {
  type        = string
  default     = "kloudjet-node-app-ping"
  description = "Name of the Apprunner Service"
}

variable "connection_arn" {
  type = string
  default = null
  description = "ARN of the App Runner connection that enables the App Runner service to connect to a source repository"
}

variable "auto_deployments_enabled" {
  type        = bool
  default     = false
  description = "Whether continuous integration from the source repository is enabled for the App Runner service, if set to true, each repository change (source code commit or new image version) starts a deployment, defaults to true"
}

variable "code_repository" {
  type = bool
  default = false
  description = "Whether to create a source code repository"
}

variable "build_command" {
  type = string
  default = null
  description = "Command App Runner runs to build your application"
}

variable "apprunner_port" {
  type = string
  default = null
  description = "Port that your application listens to in the container"  
}

variable "runtime" {
  type = string
  default = null
  description = "Runtime environment type for building and running an App Runner service, represents a programming language runtime"
}

variable "runtime_environment_secrets" {
  type = map
  default = {}
  description = "Secrets and parameters available to your service as environment variables, a map of key/value pairs, where the key is the desired name of the Secret in the environment (i.e. it does not have to match the name of the secret in Secrets Manager or SSM Parameter Store), and the value is the ARN of the secret from AWS Secrets Manager or the ARN of the parameter in AWS SSM Parameter Store"  
}

variable "runtime_environment_variables" {
  type = map
  default = {}
  description = "Environment variables available to your running App Runner service, a map of key/value pairs, keys with a prefix of AWSAPPRUNNER are reserved for system use and aren't valid"  
}

variable "start_command" {
  type = string
  default = null
  description = "Command App Runner runs to start your application"  
}

variable "configuration_source" {
  type = string
  default = null
  description ="Source of the App Runner configuration" 
}

variable "repository_url" {
  type = string
  default = null
  description = "Location of the repository that contains the source code"  
}

variable "source_code_type" {
  type = string
  default = null
  description = "Type of version identifier, for a git-based repository, branches represent versions, valid values: BRANCH" 
}

variable "source_code_value" {
  type = string
  default = null
  description = "Source code version, for a git-based repository, a branch name maps to a specific version, App Runner uses the most recent commit to the branch"  
}

variable "image_repository" {
  type = bool
  default = true
  description = "Whether to create a source image repository"
}

variable "port" {
  type        = string
  default     = "8080"
  description = "Port that your application listens to in the container, defaults to 8080"
}

variable "image_runtime_environment_secrets" {
  type = map
  default = {}
  description = "Secrets and parameters available to your service as environment variables, a map of key/value pairs, where the key is the desired name of the Secret in the environment (i.e. it does not have to match the name of the secret in Secrets Manager or SSM Parameter Store), and the value is the ARN of the secret from AWS Secrets Manager or the ARN of the parameter in AWS SSM Parameter Store" 
}

variable "image_runtime_environment_variables" {
  type = map
  default = {}
  description = "Environment variables available to your running App Runner service, a map of key/value pairs, keys with a prefix of AWSAPPRUNNER are reserved for system use and aren't valid"  
}

variable "image_start_command" {
  type = string
  default = null
  description = "Command App Runner runs to start the application in the source image, if specified, this command overrides the Docker image default start command"  
}

variable "image_tag" {
  description = "Tag to be used with image"
  type = string
  default = "latest"
}

variable "image_repository_type" {
  type = string
  default = "ECR"
  description = "Type of the ECR image repository"  
}

variable "auto_scaling_configuration_arn" {
  type = string
  default = null
  description = "ARN of an App Runner automatic scaling configuration resource that you want to associate with your service, if not provided, App Runner associates the latest revision of a default auto scaling configuration"  
}

variable "encryption_kms_key" {
  type = string
  default = ""
  description = "ARN of the KMS key used for encryption"
}

variable "healthy_threshold" {
  type = number
  default = 1
  description = "Number of consecutive checks that must succeed before App Runner decides that the service is healthy, defaults to 1, minimum value of 1, maximum value of 20"  
}

variable "interval" {
  type = number
  default = 5
  description = "Time interval, in seconds, between health checks, defaults to 5, minimum value of 1, maximum value of 20"  
}

variable "health_path" {
  type = string
  default = "/"
  description = "URL to send requests to for health check, defaults to /, minimum length of 0, maximum length of 51200"
}

variable "health_protocol" {
  type = string
  default = "TCP"
  description = "IP protocol that App Runner uses to perform health checks for your service"  
}

variable "health_timeout" {
  type = number
  default = 2
  description = "Time, in seconds, to wait for a health check response before deciding it failed, defaults to 2, minimum value of 1, maximum value of 20"  
}

variable "unhealthy_threshold" {
  type = number
  default = 5
  description = "Number of consecutive checks that must fail before App Runner decides that the service is unhealthy, defaults to 5, minimum value of 1, maximum value of 20"
}

variable "instance_cpu" {
  type = string
  default = "1024"
  description = "Number of CPU units reserved for each instance of your App Runner service represented as a String, defaults to 1024, valid values: 256|512|1024|2048|4096|(0.25|0.5|1|2|4) vCPU"
}

variable "instance_role_arn" {
  type = string
  default = null
  description = "ARN of an IAM role that provides permissions to your App Runner service"
}

variable "instance_memory" {
  type = number
  default = 2048
  description = "Amount of memory, in MB or GB, reserved for each instance of your App Runner service, defaults to 2048, valid values: 512|1024|2048|3072|4096|6144|8192|10240|12288|(0.5|1|2|3|4|6|8|10|12) GB"
}

variable "is_publicly_accessible" {
  type = bool
  default = true
  description = "Specifies whether your App Runner service is publicly accessible"
}

variable "egress_type" {
  type = string
  default = "DEFAULT"
  description = "The type of egress configuration"
}

variable "vpc_connector_arn" {
  type = string
  default = null
  description = "The Amazon Resource Name (ARN) of the App Runner VPC connector that you want to associate with your App Runner service"  
}

variable "observability_enabled"{
  type = bool
  default = false
  description = "When true, an observability configuration resource is associated with the service"
}

variable "observability_configuration_arn"{
  type = string
  default = null
  description = "ARN of the observability configuration that is associated with the service"
}

variable "apprunner_tags" {
  type = map
  default = {}
  description = "Key-value map of AppRunner resource tags"
}