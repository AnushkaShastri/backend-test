variable "region" {
  description = "AWS Region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "iam_policy_name" {
  description = "The name of the IAM role policy. If omitted, Terraform will assign a random, unique name"
  type        = string
  default     = "kloudjet-spring-app-iam-policy"
}

variable "iam_role_name" {
  description = "Name of the IAM role. If omitted, Terraform will assign a random, unique name"
  type        = string
  default     = "kloudjet-spring-app-iam-role"
}

variable "repo_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "kloudjet-spring-app-repo"
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE"
  type        = string
  default     = "IMMUTABLE"
}

variable "force_delete" {
  description = "Delete ECR repository if it contains"
  type = bool
  default = true
}

variable "apprunner_service_name" {
  description = "Name of the Apprunner Service"
  type        = string
  default     = "kloudjet-spring-app-ping"
}

variable "port" {
  description = "Port that your application listens to in the container. Defaults to 8080"
  type        = string
  default     = "8080"
}

variable "image_tag" {
  description = "Tag to be used with image"
  type = string
  default = "latest"
}

variable "auto_deployments_enabled" {
  description = "Whether continuous integration from the source repository is enabled for the App Runner service. If set to true, each repository change (source code commit or new image version) starts a deployment. Defaults to true"
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
