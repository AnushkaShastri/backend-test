variable "repoName" {
  type    = string
  default = "kloudjet-python-app-repo"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "imageTag" {
  type    = string
  default = "latest"
}

variable "policy_name" {
  description = "(Optional) The name of the role policy."
  type        = string
  default     = "python-apprunner-iam-policy"
}

variable "iam_role_name" {
  description = " (Optional, Forces new resource) Friendly name of the role."
  type        = string
  default     = "python-apprunner-iam-role"
}

variable "image_tag_mutability" {
  description = "(Optional) The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE"
  type        = string
  default     = "IMMUTABLE"
}

variable "service_name" {
  description = " (Forces new resource) Name of the service"
  type        = string
  default     = "python-apprunner-ping"
}


variable "port" {
  description = "(Optional) Port that your application listens to in the container. Defaults to 8080"
  type        = string
  default     = "8000"
}

variable "image_repository_type" {
  description = "(Required) Type of the image repository. This reflects the repository provider and whether the repository is private or public. Valid values: ECR , ECR_PUBLIC."
  type        = string
  default     = "ECR"
}

variable "auto_deployments_enabled" {
  description = "(Optional) Whether continuous integration from the source repository is enabled for the App Runner service. If set to true, each repository change (source code commit or new image version) starts a deployment. Defaults to true."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(any)
  default = {
    Name = "Backend-apprunner-service"
  }
}
variable "force_delete" {
  description = "Delete ECR repository if it contains"
  type = bool
  default = true
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
