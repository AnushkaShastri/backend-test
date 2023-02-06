variable "region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}
variable "log_bucket_name" {
  description = "The name of the log bucket. If omitted, Terraform will assign a random, unique name. Must be lowercase and less than or equal to 63 characters in length"
  type        = string
  default     = "kloudjet-react-frontend-log-bucket"
}
variable "deployment_bucket_name" {
  description = "The name of the deployment bucket. If omitted, Terraform will assign a random, unique name. Must be lowercase and less than or equal to 63 characters in length"
  type        = string
  default     = "kloudjet-react-frontend-deployment-bucket"
}
variable "log_bucket_force_destroy" {
  description = "A boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. These objects are not recoverable. This only deletes objects when the bucket is destroyed, not when setting this parameter to true"
  type        = bool
  default     = true
}
variable "log_bucket_access_control" {
  description = "The canned ACL to apply to the bucket"
  type        = string
  default     = "public-read"
}
variable "deployment_bucket_force_destroy" {
  description = "A boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. These objects are not recoverable. This only deletes objects when the bucket is destroyed, not when setting this parameter to true"
  type        = bool
  default     = true
}
variable "deployment_bucket_access_control" {
  description = "The canned ACL to apply to the bucket"
  type        = string
  default     = "public-read"
}
variable "index_document" {
  description = "A suffix that is appended to a request that is for a directory on the website endpoint. For example, if the suffix is index.html and you make a request to samplebucket/images/, the data that is returned will be for the object with the key name images/index.html. The suffix must not be empty and must not include a slash character"
  type        = string
  default     = "index.html"
}
variable "error_document" {
  description = "The object key name to use when a 4XX class error occurs"
  type        = string
  default     = "error.html"
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
  default     = ["TLSv1"]
}

variable "enabled" {
  description = "Whether the distribution is enabled to accept end user requests for content"
  type        = bool
  default     = true
}

variable "is_ipv6_enabled" {
  description = "Whether the IPv6 is enabled for the distribution"
  type        = bool
  default     = true
}

variable "default_root_object" {
  description = "The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL"
  type        = string
  default     = "index.html"
}

variable "include_cookies" {
  description = "Specifies whether you want CloudFront to include cookies in access logs"
  type        = bool
  default     = false
}

variable "prefix" {
  description = "An optional string that you want CloudFront to prefix to the access log filenames for this distribution"
  type        = string
  default     = "kloudjet"
}

variable "error_caching_min_ttl" {
  description = "The minimum amount of time you want HTTP error codes to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated"
  type        = number
  default     = 3000
}

variable "error_code" {
  description = "The 4xx or 5xx HTTP status code that you want to customize"
  type        = number
  default     = 404
}

variable "response_code" {
  description = "The HTTP status code that you want CloudFront to return with the custom error page to the viewer"
  type        = number
  default     = 200
}

variable "response_page_path" {
  description = "The path of the custom error page"
  type        = string
  default     = "/"
}

variable "allowed_methods" {
  description = "Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin"
  type        = list(any)
  default     = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}

variable "cached_methods" {
  description = "Controls whether CloudFront caches the response to requests using the specified HTTP methods"
  type        = list(any)
  default     = ["GET", "HEAD"]
}

variable "query_string" {
  description = "Indicates whether you want CloudFront to forward query strings to the origin that is associated with this cache behavior."
  type        = bool
  default     = true
}

variable "forward" {
  description = "Whether you want CloudFront to forward cookies to the origin that is associated with this cache behavior. You can specify all, none or whitelist"
  type        = string
  default     = "none"
}

variable "viewer_protocol_policy" {
  description = "Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https"
  type        = string
  default     = "allow-all"
}

variable "min_ttl" {
  description = "The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. Defaults to 0 seconds"
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header"
  type        = number
  default     = 3600
}

variable "max_ttl" {
  description = "The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. Only effective in the presence of Cache-Control max-age, Cache-Control s-maxage, and Expires headers"
  type        = number
  default     = 86400
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
  description = "Tags attached in each resource contains details of the author, Project ID and Component ID"
  type        = string
}
variable "project" {
  description = "Tags attached in each resource contains details of the author, Project ID and Component ID"
  type        = string
}
variable "projectComponent" {
  description = "Tags attached in each resource contains details of the author, Project ID and Component ID"
  type        = string
}
