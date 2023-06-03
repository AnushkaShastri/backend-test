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

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region where resources will be deployed"
}

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

variable "iam_role_description" {
  type = string
  default = null
  description = "Description of the IAM Role"  
}

variable "force_detach_policies" {
  type = bool
  default = true
  description = "Whether to force detaching any policies the role has before destroying it"
}

variable "max_session_duration" {
  type = number
  default = 3600
  description = "Maximum session duration (in seconds) that you want to set for the specified role, if you do not specify a value for this setting, the default maximum of one hour is applied, this setting can have a value from 1 hour to 12 hours"
}

variable "iam_path" {
  type = string
  default = "/"
  description = "Path to the role"
}

variable "iam_role_name" {
  type        = string
  default     = "kloudjet-node-app-iam-role"
  description = "Name of the IAM role, if omitted, Terraform will assign a random, unique name"
}

variable "iam_role_prefix" {
  type = string
  default = null
  description = "Creates a unique friendly name beginning with the specified prefix, conflicts with name"
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

variable "encryption_configuration" {
  type = list
  default = []
  description = "Encryption configuration for the repository"
}

variable "ecr_force_delete" {
  type = bool
  default = true
  description = "Delete ECR repository if it contains"
}

variable "image_tag_mutability" {
  type        = string
  default     = "IMMUTABLE"
  description = "The tag mutability setting for the repository, must be one of: MUTABLE or IMMUTABLE, defaults to MUTABLE"
}

variable "image_scanning_configuration" {
  type = map
  default = {}
  description = "Configuration block that defines image scanning configuration for the repository"
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

variable "auto_deployments_enabled" {
  type        = bool
  default     = true
  description = "Whether continuous integration from the source repository is enabled for the App Runner service, if set to true, each repository change (source code commit or new image version) starts a deployment, defaults to true"
}

variable "image_port" {
  type = string
  default = "8080"
  description = "value"
}

variable "image_runtime_environment_secrets" {
  type = map
  default = {}
  description = "value"
}

variable "image_runtime_environment_variables" {
  type = map
  default = {}
  description = "value"
}

variable "image_start_command" {
  type = string
  default = null
  description = "Command App Runner runs to start the application in the source image"
}

variable "image_tag" {
  type = string
  default = "latest"
  description = "Tag to be used with ECR image"
}

variable "image_repository_type" {
  type = string
  default = "ECR"
  description = "Type of the image repository, this reflects the repository provider and whether the repository is private or public" 
}

variable "auto_scaling_configuration_arn" {
  type = string
  default = null
  description = "ARN of an App Runner automatic scaling configuration resource that you want to associate with your service"
}

variable "apprunner_encryption_configuration" {
  type = map
  default = {}
  description = "An optional custom encryption key that App Runner uses to encrypt the copy of your source repository that it maintains and your service logs"
}

variable "health_check_configuration" {
  type = map
  default = {}
  description = "Settings of the health check that AWS App Runner performs to monitor the health of your service"
}

variable "instance_configuration" {
  type = map
  default = {}
  description = "The runtime configuration of instances (scaling units) of the App Runner service"
}

variable "network_configuration" {
  type = map
  default = {}
  description = "Configuration settings related to network traffic of the web application that the App Runner service runs"
}

variable "observability_configuration" {
    type = map
    default = {}
    description = "The observability configuration of your service"
}

variable "apprunner_tags" {
  type = map
  default = {}
  description = "Key-value map of AppRunner resource tags"
}