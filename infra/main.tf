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
  # instance_count              = (var.instance_count == "null" || var.instance_count == null) ? 0 : var.instance_count
  associate_public_ip_address = (var.associate_public_ip_address == "null" || var.associate_public_ip_address == null) ? null : var.associate_public_ip_address
  availability_zone           = var.availability_zone == "null" ? null : var.availability_zone
  is_t_instance_type                   = replace(var.instance_type, "/^t(2|3|3a){1}\\..*$/", "1") == "1" ? true : false
  disable_api_stop                     = (var.disable_api_stop == "null" || var.disable_api_stop == null) ? null : var.disable_api_stop
  disable_api_termination              = (var.disable_api_termination == "null" || var.disable_api_termination == null) ? null : var.disable_api_termination
  ebs_optimized                        = (var.ebs_optimized == "null" || var.ebs_optimized == null) ? null : var.ebs_optimized
  get_password_data                    = (var.get_password_data == "null" || var.get_password_data == null) ? null : var.get_password_data
  hibernation                          = (var.hibernation == "null" || var.hibernation == null) ? null : var.hibernation
  host_id                              = var.host_id == "null" ? null : var.host_id
  host_resource_group_arn              = var.host_resource_group_arn == "null" ? null : var.host_resource_group_arn
  iam_instance_profile                 = var.iam_instance_profile == "null" ? null : var.iam_instance_profile
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior == "null" ? null : var.instance_initiated_shutdown_behavior
  instance_type                        = var.instance_type == "null" ? null : var.instance_type
  ipv6_address_count                   = (var.ipv6_address_count == "null" || var.ipv6_address_count == null) ? null : var.ipv6_address_count
  key_name                             = var.key_name == "null" ? null : var.key_name
  monitoring                           = (var.monitoring == "null" || var.monitoring == null) ? null : var.monitoring
  placement_group                      = var.placement_group == "null" ? null : var.placement_group
  placement_partition_number           = (var.placement_partition_number == "null" || var.placement_partition_number == null) ? null : var.placement_partition_number
  private_ip                           = var.private_ip == "null" ? null : var.private_ip
  source_dest_check                    = (var.source_dest_check == "null" || var.source_dest_check == null) ? null : var.source_dest_check
  subnet_id                            = var.subnet_id == "null" ? null : var.subnet_id
  tenancy                              = var.tenancy == "null" ? null : var.tenancy
  user_data                            = var.user_data == "null" ? null : var.user_data
  user_data_base64                     = var.user_data_base64 == "null" ? null : var.user_data_base64
  user_data_replace_on_change          = (var.user_data_replace_on_change == "null" || var.user_data_replace_on_change == null) ? null : var.user_data_replace_on_change
  # volume_attachment_count              = (var.volume_attachment_count == "null" || var.volume_attachment_count == null) ? 0 : var.volume_attachment_count
  aws_volume_attachment_device         = var.aws_volume_attachment_device == "null" ? null : var.aws_volume_attachment_device
  volume_force_detach                  = (var.volume_force_detach == "null" || var.volume_force_detach == null) ? null : var.volume_force_detach
  skip_destroy                         = (var.skip_destroy == "null" || var.skip_destroy == null) ? null : var.skip_destroy
  stop_instance_before_detaching       = (var.stop_instance_before_detaching == "null" || var.stop_instance_before_detaching == null) ? null : var.stop_instance_before_detaching
  ebs_encrypted                        = (var.ebs_encrypted == "null" || var.ebs_encrypted == null) ? null : var.ebs_encrypted
  final_snapshot                       = (var.final_snapshot == "null" || var.final_snapshot == null) ? null : var.final_snapshot
  multi_attach_enabled                 = (var.multi_attach_enabled == "null" || var.multi_attach_enabled == null) ? null : var.multi_attach_enabled
  ebs_iops                             = var.ebs_iops == "null" ? null : var.ebs_iops
  ebs_size                             = (var.ebs_size == "null" || var.ebs_size == null) ? null : var.ebs_size
  snapshot_id                          = var.snapshot_id == "null" ? null : var.snapshot_id
  outpost_arn                          = var.outpost_arn == "null" ? null : var.outpost_arn
  ebs_type                             = var.ebs_type == "null" ? null : var.ebs_type
  kms_key_id                           = var.kms_key_id == "null" ? null : var.kms_key_id
  throughput                           = var.throughput == "null" ? null : var.throughput
}

module "security_group" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = "${var.env}_${var.security_group_name}"
  description         = var.sg_description
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = var.ingress_cidr_blocks
  ingress_rules       = var.ingress_rules
  egress_rules        = var.egress_rules
}

resource "aws_instance" "instance" {
  # count                       = local.instance_count
  ami                         = var.ami_id
  associate_public_ip_address = local.associate_public_ip_address
  availability_zone           = local.availability_zone
  dynamic "capacity_reservation_specification" {
    for_each = length(var.capacity_reservation_specification) == 0 ? [] : [var.capacity_reservation_specification]
    content {
      capacity_reservation_preference = lookup(capacity_reservation_specification.value, "capacity_reservation_preference", null)
      capacity_reservation_target {
          capacity_reservation_id                 = lookup(capacity_reservation_specification.value, "capacity_reservation_id", null)
          capacity_reservation_resource_group_arn = lookup(capacity_reservation_specification.value, "capacity_reservation_resource_group_arn", null)
      }
    }
  }
  dynamic "cpu_options" {
    for_each = length(var.cpu_options) == 0 ? [] : [var.cpu_options]
    content {
      amd_sev_snp      = lookup(cpu_options.value, "amd_sev_snp", null)
      core_count       = lookup(cpu_options.value, "core_count", null)
      threads_per_core = lookup(cpu_options.value, "threads_per_core", null)
    }
  }
  dynamic "credit_specification" {
    for_each = length(var.credit_specification) == 0 ? [] : [var.credit_specification]
    content {
      cpu_credits = local.is_t_instance_type == true ? lookup(credit_specification.value, "cpu_credits", null) : null
    }
  }
  disable_api_stop        = local.disable_api_stop
  disable_api_termination = local.disable_api_termination
  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "ebs_delete_on_termination", null)
      device_name           = ebs_block_device.value.ebs_device_name
      encrypted             = lookup(ebs_block_device.value, "ebs_encrypted", null)
      iops                  = lookup(ebs_block_device.value, "ebs_iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "ebs_kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "ebs_snapshot_id", null)
      tags                  = lookup(ebs_block_device.value, "ebs_tags", null)
      throughput            = lookup(ebs_block_device.value, "ebs_throughput", null)
      volume_size           = lookup(ebs_block_device.value, "ebs_volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "ebs_volume_type", null)
    }
  }
  ebs_optimized = local.ebs_optimized
  dynamic "enclave_options" {
    for_each = length(var.enclave_options) == 0 ? [] : [var.enclave_options]
    content {
      enabled = lookup(enclave_options.value, "enclave_enabled", null)
    }
  }
  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "ephemeral_no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "ephemeral_virtual_name", null)
    }
  }
  get_password_data                    = local.get_password_data
  hibernation                          = local.hibernation
  host_id                              = local.host_id
  host_resource_group_arn              = local.host_resource_group_arn
  iam_instance_profile                 = local.iam_instance_profile
  instance_initiated_shutdown_behavior = local.instance_initiated_shutdown_behavior
  instance_type                        = local.instance_type
  ipv6_address_count                   = local.ipv6_address_count
  ipv6_addresses                       = var.ipv6_addresses
  key_name                             = local.key_name
  dynamic "launch_template" {
    for_each = length(var.launch_template) == 0 ? [] : [var.launch_template]
    content {
      id      = lookup(launch_template.value, "launch_template_id", null)
      name    = lookup(launch_template.value, "launch_template_name", null)
      version = lookup(launch_template.value, "launch_template_version", null)
    }
  }
  dynamic "maintenance_options" {
    for_each = length(var.maintenance_options) == 0 ? [] : [var.maintenance_options]
    content {
      auto_recovery = lookup(maintenance_options.value, "auto_recovery", null)
    }
  }
  dynamic "metadata_options" {
    for_each = length(var.metadata_options) == 0 ? [] : [var.metadata_options]
    content {
      http_endpoint               = lookup(metadata_options.value, "metadata_http_endpoint", null)
      http_put_response_hop_limit = lookup(metadata_options.value, "metadata_http_put_response_hop_limit", null)
      http_tokens                 = lookup(metadata_options.value, "metadata_http_tokens", null)
      instance_metadata_tags      = lookup(metadata_options.value, "metadata_instance_metadata_tags", null)
    }
  }
  monitoring = local.monitoring
  dynamic "network_interface" {
    for_each = var.network_interface
    content {
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
      device_index          = network_interface.value.device_index
      network_card_index    = lookup(network_interface.value, "network_card_index", null)
      network_interface_id  = network_interface.value.network_interface_id
    }
  }
  placement_group            = local.placement_group
  placement_partition_number = local.placement_partition_number
  dynamic "private_dns_name_options" {
    for_each = length(var.private_dns_name_options) == 0 ? [] : [var.private_dns_name_options]
    content {
      enable_resource_name_dns_aaaa_record = lookup(private_dns_name_options.value, "enable_resource_name_dns_aaaa_record", null)
      enable_resource_name_dns_a_record    = lookup(private_dns_name_options.value, "enable_resource_name_dns_a_record", null)
      hostname_type                        = lookup(private_dns_name_options.value, "hostname_type", null)
    }
  }
  private_ip = length(var.private_ips) > 0 ? element(var.private_ips, count.index) : local.private_ip
  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      tags                  = lookup(root_block_device.value, "tags", null)
      throughput            = lookup(root_block_device.value, "throughput", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
    }
  }
  secondary_private_ips = var.secondary_private_ips
  security_groups       = var.security_groups
  source_dest_check     = length(var.network_interface) > 0 ? null : local.source_dest_check
  subnet_id             = local.subnet_id
  # tags = merge(
  #   {
  #     "Name" = local.instance_count > 1 || var.use_num_suffix ? format("%s-%d", "${var.env}_${var.name}", count.index + 1) : "${var.env}_${var.name}"
  #   },
  #   var.tags,
  # )
  tags = var.tags
  tenancy                     = local.tenancy
  user_data                   = local.user_data
  user_data_base64            = local.user_data_base64
  user_data_replace_on_change = local.user_data_replace_on_change
  # volume_tags = merge(
  #   {
  #     "Name" = local.instance_count > 1 || var.use_num_suffix ? format("%s-%d", "${var.env}_${var.name}", count.index + 1) : "${var.env}_${var.name}"
  #   },
  #   var.volume_tags,
  # )
  volume_tags = var.volume_tags
  vpc_security_group_ids = [module.security_group.security_group_id]
}

resource "aws_volume_attachment" "this_ec2" {
  # count                          = local.volume_attachment_count
  device_name                    = local.aws_volume_attachment_device
  # instance_id                    = aws_instance.instance[count.index].id
  # volume_id                      = aws_ebs_volume.this[count.index].id
  instance_id                    = aws_instance.instance.id
  volume_id                      = aws_ebs_volume.this.id
  force_detach                   = local.volume_force_detach
  skip_destroy                   = local.skip_destroy
  stop_instance_before_detaching = local.stop_instance_before_detaching
}

resource "aws_ebs_volume" "this" {
  # count                = local.volume_attachment_count
  # availability_zone    = aws_instance.instance[count.index].availability_zone
  availability_zone = local.availability_zone
  encrypted            = local.ebs_encrypted
  final_snapshot       = local.final_snapshot
  iops                 = local.ebs_iops
  multi_attach_enabled = local.multi_attach_enabled
  size                 = local.ebs_size
  snapshot_id          = local.snapshot_id
  outpost_arn          = local.outpost_arn
  type                 = local.ebs_type
  kms_key_id           = local.kms_key_id
  tags                 = var.ebs_tags
  throughput           = local.throughput
}