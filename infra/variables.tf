variable "env" {
  description = "Environment for which all the resources are being provisioned, being used as prefix for resource name"
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

variable "region" {
  description = "AWS region where all resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI to use for the instance"
  type        = string
  default     = "ami-0715c1897453cabd1"
}

variable "security_group_name" {
  description = "Name of security group"
  type        = string
  default     = "kloudjet_security_group_ec2"
}

variable "sg_description" {
  description = "Description of the EC2 Security Group"
  type        = string
  default     = "Security group for usage with EC2 instance"
}

variable "vpc_id" {
  description = "The id of the specific VPC to retrieve"
  type        = string
  default     = null
}

variable "ingress_cidr_blocks" {
  description = "List of CIDR blocks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  type        = list(string)
  default     = ["http-80-tcp", "all-icmp", "ssh-tcp"]
}

variable "egress_rules" {
  description = "List of egress rules to create by name"
  type        = list(string)
  default     = ["all-all"]
}

variable "instance_count" {
  description = "Number of EC2 instances to launch"
  type        = string
  default     = 1
}

variable "associate_public_ip_address" {
  description = "If true, the EC2 instance will have associated public IP address"
  type        = string
  default     = true
}

variable "availability_zone" {
  description = "AZ to start the instance in"
  type        = string
  default     = null
}

variable "capacity_reservation_specification" {
  description = "Describes an instance's Capacity Reservation targeting option"
  type        = map(any)
  default     = {}
}

variable "cpu_options" {
  description = "The CPU options for the instance"
  type        = map(any)
  default     = {}
}

variable "credit_specification" {
  description = "Configuration block for customizing the credit specification of the instance"
  type        = map(any)
  default     = {}
}

variable "disable_api_stop" {
  description = "If true, enables EC2 Instance Stop Protection"
  type        = string
  default     = null
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  type        = string
  default     = null
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(any)
  default     = []
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized, if the instance type is optimized by default then there is no need to set this and there is no effect to disabling it"
  type        = string
  default     = false
}

variable "enclave_options" {
  description = "Whether Nitro Enclaves will be enabled on the instance, defaults to false"
  type        = map(any)
  default     = {}
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  type        = list(any)
  default     = []
}

variable "get_password_data" {
  description = "If true, wait for password data to become available and retrieve it."
  type        = string
  default     = false
}

variable "hibernation" {
  description = "If true, the launched EC2 instance will support hibernation"
  type        = string
  default     = null
}

variable "host_id" {
  description = "ID of a dedicated host that the instance will be assigned to, use when an instance is to be launched on a specific dedicated host"
  type        = string
  default     = null
}

variable "host_resource_group_arn" {
  description = "ARN of the host resource group in which to launch the instances, if you specify an ARN, omit the tenancy parameter or set it to host"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "The IAM Instance Profile to launch the instance with, specified as the name of the Instance Profile"
  type        = string
  default     = "EC2_Can_Use_Services"
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t2.micro"
}

variable "ipv6_address_count" {
  description = "A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet."
  type        = string
  default     = null
}

variable "ipv6_addresses" {
  description = "Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
  default     = null
}

variable "launch_template" {
  description = "Specifies a Launch Template to configure the instance, parameters configured on this resource will override the corresponding parameters in the Launch Template"
  type        = map(any)
  default     = {}
}

variable "maintenance_options" {
  description = "Maintenance and recovery options for the instance"
  type        = map(any)
  default     = {}
}

variable "metadata_options" {
  description = "Customize the metadata options of the instance"
  type        = map(any)
  default     = {}
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = string
  default     = false
}

variable "network_interface" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = list(any)
  default     = []
}

variable "placement_group" {
  description = "The Placement Group to start the instance in"
  type        = string
  default     = null
}

variable "placement_partition_number" {
  description = "Number of the partition the instance is in, valid only if the aws_placement_group resource's strategy argument is set to 'partition'"
  type        = string
  default     = null
}

variable "private_dns_name_options" {
  description = "Options for the instance hostname, the default values are inherited from the subnet"
  type        = map(any)
  default     = {}
}

variable "private_ips" {
  description = "A list of private IP address to associate with the instance in a VPC. Should match the number of instances."
  type        = list(string)
  default     = []
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance, see Block Devices below for details"
  type        = list(any)
  default     = []
}

variable "secondary_private_ips" {
  description = "List of secondary private IPv4 addresses to assign to the instance's primary network interface (eth0) in a VPC"
  type        = list(any)
  default     = []
}

variable "security_groups" {
  description = "List of security group names to associate with"
  type        = list(any)
  default     = []
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs."
  type        = string
  default     = true
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
}

variable "use_num_suffix" {
  description = "Always append numerical suffix to instance name, even if instance_count is 1"
  type        = string
  default     = false
}

variable "name" {
  description = "Name to be used on all resources as prefix"
  type        = string
  default     = "kloudjet_ec2"
}

variable "tags" {
  description = "A mapping of string tags to assign to the EC2 resource"
  type        = map(string)
  default     = {}
}

variable "tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC). Available values: default, dedicated, host."
  type        = string
  default     = "default"
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead."
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption."
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "When used in combination with user_data or user_data_base64 will trigger a destroy and recreate when set to true, defaults to false"
  type        = string
  default     = null
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  type        = map(any)
  default     = {}
}

variable "volume_attachment_count" {
  description = "Used in count for indexing and obtaining argument values in aws_volume_attachment and aws_ebs_volume resources"
  type        = string
  default     = 1
}

variable "aws_volume_attachment_device" {
  description = "The device name to expose to the instance"
  type        = string
  default     = "xvdh"
}

variable "volume_force_detach" {
  description = "Set to true if you want to force the volume to detach"
  type        = string
  default     = false
}

variable "skip_destroy" {
  description = "Set this to true if you do not wish to detach the volume from the instance to which it is attached at destroy time, and instead just remove the attachment from Terraform state"
  type        = string
  default     = false
}

variable "stop_instance_before_detaching" {
  description = "Set this to true to ensure that the target instance is stopped before trying to detach the volume"
  type        = string
  default     = false
}

variable "ebs_encrypted" {
  description = "If true, the disk will be encrypted"
  type        = string
  default     = false
}

variable "final_snapshot" {
  description = "If true, snapshot will be created before volume deletion, any tags on the volume will be migrated to the snapshot"
  type        = string
  default     = false
}

variable "ebs_iops" {
  description = "The amount of IOPS to provision for the disk"
  type        = string
  default     = null
}

variable "multi_attach_enabled" {
  description = "Specifies whether to enable Amazon EBS Multi-Attach"
  type        = string
  default     = false
}

variable "ebs_size" {
  description = "The size of the drive in GiBs"
  type        = string
  default     = 2
}

variable "snapshot_id" {
  description = "A snapshot to base the EBS volume off of"
  type        = string
  default     = null
}

variable "outpost_arn" {
  description = "The Amazon Resource Name (ARN) of the Outpost"
  type        = string
  default     = null
}

variable "ebs_type" {
  description = "The type of EBS volume"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "he ARN for the KMS encryption key"
  type        = string
  default     = null
}

variable "ebs_tags" {
  description = "A map of tags to assign to the resource"
  type        = map(any)
  default     = {}
}

variable "throughput" {
  description = "The throughput that the volume supports, in MiB/s"
  type        = string
  default     = null
}