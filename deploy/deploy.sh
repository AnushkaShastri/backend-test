for i in $@
do
var=$(echo $i | cut -f1 -d =)
declare $var=$(echo $i | cut -f2- -d =)
done

[[ -z "$access_key" ]] && echo "AWS Access Key is Required" && exit 1
[[ -z "$secret_key" ]] && echo "AWS Secret Key is Required" && exit 1

[[ -z "$env" ]] && echo "Environment is Required" && exit 1
[[ -z "$file" ]] && echo "JSON Configurations file is Required" && exit 1
[[ -z "$mode" ]] && echo "Terraform backend mode is Required" && exit 1

[[ -z "$createdBy" ]] && echo "Created By Tag is Required" && exit 1
[[ -z "$project" ]] && echo "Project Tag is Required" && exit 1
[[ -z "$projectComponent" ]] && echo "Project Component Tag is Required" && exit 1

echo mode : $mode
if [ "$mode" == "cicd" ];
then
    [[ -z "$tf_http_address" ]] && echo "Terraform Remote Backend Address is Required" && exit 1
    [[ -z "$tf_http_lock_address" ]] && echo "Terraform Remote Backend Lock Address is Required" && exit 1
    [[ -z "$tf_http_unlock_address" ]] && echo "Terraform Remote Backend Unlock Address is Required" && exit 1
    [[ -z "$tf_http_username" ]] && echo "Terraform Remote Backend Username is Required" && exit 1
    [[ -z "$tf_http_password" ]] && echo "Terraform Remote Backend Password is Required" && exit 1

    echo "Setting Terraform HTTP backend environment variables..."
    export TF_HTTP_ADDRESS=$tf_http_address/$env
    export TF_HTTP_LOCK_ADDRESS=$tf_http_lock_address/$env
    export TF_HTTP_UNLOCK_ADDRESS=$tf_http_unlock_address/$env
    export TF_HTTP_USERNAME=$tf_http_username
    export TF_HTTP_PASSWORD=$tf_http_password
fi

declare -A arr
while IFS== read key value; do
 printf -v "$key" "$value"  
 arr[$key]=$key
done < <(jq 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' $file | sed -e 's/^"//' -e 's/"$//')
envObj=${arr[$env]}
while IFS== read key value; do
 printf -v "$key" "%s" "$value"
done < <(jq 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' <<< ${!envObj} | sed -e 's/^"//' -e 's/"$//')

[[ -z "$region" ]] && region="us-east-1" 
[[ -z "$ami_id" ]] && ami_id="ami-0715c1897453cabd1" 
[[ -z "$security_group_name" ]] && security_group_name="kloudjet_security_group_ec2" 
[[ -z "$sg_description" ]] && sg_description="Security_group_for_usage_with_EC2_instance" 
[[ -z "$vpc_id" ]] && echo "VPC ID is Required" && exit 1
[[ -z "$ingress_cidr_blocks" ]] && ingress_cidr_blocks="[\"0.0.0.0/0\"]" 
[[ -z "$ingress_rules" ]] && ingress_rules="[\"http-80-tc\",\"all-icm\",\"ssh-tcp\"]" 
[[ -z "$egress_rules" ]] && egress_rules="[\"all-all\"]" 
[[ -z "$instance_count" ]] && instance_count="1" 
[[ -z "$associate_public_ip_address" ]] && associate_public_ip_address="true" 
[[ -z "$availability_zone" ]] && availability_zone="null" 
[[ -z "$capacity_reservation_specification" ]] && capacity_reservation_specification={} 
[[ -z "$cpu_options" ]] && cpu_options={} 
[[ -z "$credit_specification" ]] && credit_specification={} 
[[ -z "$disable_api_stop" ]] && disable_api_stop="null" 
[[ -z "$disable_api_termination" ]] && disable_api_termination="null" 
[[ -z "$ebs_block_device" ]] && ebs_block_device=[] 
[[ -z "$ebs_optimized" ]] && ebs_optimized="false" 
[[ -z "$enclave_options" ]] && enclave_options={} 
[[ -z "$ephemeral_block_device" ]] && ephemeral_block_device=[] 
[[ -z "$get_password_data" ]] && get_password_data="false" 
[[ -z "$hibernation" ]] && hibernation="null" 
[[ -z "$host_id" ]] && host_id="null" 
[[ -z "$host_resource_group_arn" ]] && host_resource_group_arn="null" 
[[ -z "$iam_instance_profile" ]] && iam_instance_profile="EC2_Can_Use_Services" 
[[ -z "$instance_initiated_shutdown_behavior" ]] && instance_initiated_shutdown_behavior="null" 
[[ -z "$instance_type" ]] && instance_type="t2.micro" 
[[ -z "$ipv6_address_count" ]] && ipv6_address_count="null" 
[[ -z "$ipv6_addresses" ]] && ipv6_addresses=[] 
[[ -z "$key_name" ]] && key_name="null" 
[[ -z "$launch_template" ]] && launch_template={} 
[[ -z "$maintenance_options" ]] && maintenance_options={} 
[[ -z "$metadata_options" ]] && metadata_options={} 
[[ -z "$monitoring" ]] && monitoring="false" 
[[ -z "$network_interface" ]] && network_interface=[] 
[[ -z "$placement_group" ]] && placement_group="null" 
[[ -z "$placement_partition_number" ]] && placement_partition_number="null" 
[[ -z "$private_dns_name_options" ]] && private_dns_name_options={} 
[[ -z "$private_ips" ]] && private_ips=[] 
[[ -z "$private_ip" ]] && private_ip="null" 
[[ -z "$root_block_device" ]] && root_block_device=[] 
[[ -z "$secondary_private_ips" ]] && secondary_private_ips=[] 
[[ -z "$security_groups" ]] && security_groups=[] 
[[ -z "$source_dest_check" ]] && source_dest_check="true" 
[[ -z "$subnet_id" ]] && subnet_id="null" 
[[ -z "$use_num_suffix" ]] && use_num_suffix="false" 
[[ -z "$name" ]] && name="kloudjet_ec2" 
[[ -z "$tags" ]] && tags={} 
[[ -z "$tenancy" ]] && tenancy="default" 
[[ -z "$user_data" ]] && user_data="null" 
[[ -z "$user_data_base64" ]] && user_data_base64="null" 
[[ -z "$user_data_replace_on_change" ]] && user_data_replace_on_change="null" 
[[ -z "$volume_tags" ]] && volume_tags={} 
[[ -z "$volume_attachment_count" ]] && volume_attachment_count="1" 
[[ -z "$aws_volume_attachment_device" ]] && aws_volume_attachment_device="xvdh" 
[[ -z "$volume_force_detach" ]] && volume_force_detach="false" 
[[ -z "$skip_destroy" ]] && skip_destroy="false" 
[[ -z "$stop_instance_before_detaching" ]] && stop_instance_before_detaching="false" 
[[ -z "$ebs_encrypted" ]] && ebs_encrypted="false" 
[[ -z "$final_snapshot" ]] && final_snapshot="false" 
[[ -z "$ebs_iops" ]] && ebs_iops="null" 
[[ -z "$multi_attach_enabled" ]] && multi_attach_enabled="false" 
[[ -z "$ebs_size" ]] && ebs_size="2" 
[[ -z "$snapshot_id" ]] && snapshot_id="null" 
[[ -z "$outpost_arn" ]] && outpost_arn="null" 
[[ -z "$ebs_type" ]] && ebs_type="null" 
[[ -z "$kms_key_id" ]] && kms_key_id="null" 
[[ -z "$ebs_tags" ]] && ebs_tags={} 
[[ -z "$throughput" ]] && throughput="null"

echo "Following variable values will be used for deployment..."

echo region : $region
echo ami_id : $ami_id
echo security_group_name : $security_group_name
echo sg_description : $sg_description
echo vpc_id : $vpc_id
echo ingress_cidr_blocks : $ingress_cidr_blocks
echo ingress_rules : $ingress_rules
echo egress_rules : $egress_rules
echo instance_count : $instance_count
echo associate_public_ip_address : $associate_public_ip_address
echo availability_zone : $availability_zone
echo capacity_reservation_specification : $capacity_reservation_specification
echo cpu_options : $cpu_options
echo credit_specification : $credit_specification
echo disable_api_stop : $disable_api_stop
echo disable_api_termination : $disable_api_termination
echo ebs_block_device : $ebs_block_device
echo ebs_optimized : $ebs_optimized
echo enclave_options : $enclave_options
echo ephemeral_block_device : $ephemeral_block_device
echo get_password_data : $get_password_data
echo hibernation : $hibernation
echo host_id : $host_id
echo host_resource_group_arn : $host_resource_group_arn
echo iam_instance_profile : $iam_instance_profile
echo instance_initiated_shutdown_behavior : $instance_initiated_shutdown_behavior
echo instance_type : $instance_type
echo ipv6_address_count : $ipv6_address_count
echo ipv6_addresses : $ipv6_addresses
echo key_name : $key_name
echo launch_template : $launch_template
echo maintenance_options : $maintenance_options
echo metadata_options : $metadata_options
echo monitoring : $monitoring
echo network_interface : $network_interface
echo placement_group : $placement_group
echo placement_partition_number : $placement_partition_number
echo private_dns_name_options : $private_dns_name_options
echo private_ips : $private_ips
echo private_ip : $private_ip
echo root_block_device : $root_block_device
echo secondary_private_ips : $secondary_private_ips
echo security_groups : $security_groups
echo source_dest_check : $source_dest_check
echo subnet_id : $subnet_id
echo use_num_suffix : $use_num_suffix
echo name : $name
echo tags : $tags
echo tenancy : $tenancy
echo user_data : $user_data
echo user_data_base64 : $user_data_base64
echo user_data_replace_on_change : $user_data_replace_on_change
echo volume_tags : $volume_tags
echo volume_attachment_count : $volume_attachment_count
echo aws_volume_attachment_device : $aws_volume_attachment_device
echo volume_force_detach : $volume_force_detach
echo skip_destroy : $skip_destroy
echo stop_instance_before_detaching : $stop_instance_before_detaching
echo ebs_encrypted : $ebs_encrypted
echo final_snapshot : $final_snapshot
echo ebs_iops : $ebs_iops
echo multi_attach_enabled : $multi_attach_enabled
echo ebs_size : $ebs_size
echo snapshot_id : $snapshot_id
echo outpost_arn : $outpost_arn
echo ebs_type : $ebs_type
echo kms_key_id : $kms_key_id
echo ebs_tags : $ebs_tags
echo throughput : $throughput
echo createdBy : $createdBy
echo project : $project
echo projectComponent : $projectComponent
echo env : $env

echo "Configuring AWS..."
aws configure set aws_access_key_id $access_key && aws configure set aws_secret_access_key $secret_key && aws configure set default.region $region

cd infra
echo "Initializing..."
terraform init -reconfigure

echo "Setting it up will take few minutes...."
terraform apply -var region=$region -var ami_id=$ami_id -var security_group_name=$security_group_name -var sg_description=$sg_description -var vpc_id=$vpc_id -var ingress_cidr_blocks=$ingress_cidr_blocks -var ingress_rules=$ingress_rules -var egress_rules=$egress_rules -var instance_count=$instance_count -var associate_public_ip_address=$associate_public_ip_address -var availability_zone=$availability_zone -var capacity_reservation_specification=$capacity_reservation_specification -var cpu_options=$cpu_options -var credit_specification=$credit_specification -var disable_api_stop=$disable_api_stop -var disable_api_termination=$disable_api_termination -var ebs_block_device=$ebs_block_device -var ebs_optimized=$ebs_optimized -var enclave_options=$enclave_options -var ephemeral_block_device=$ephemeral_block_device -var get_password_data=$get_password_data -var hibernation=$hibernation -var host_id=$host_id -var host_resource_group_arn=$host_resource_group_arn -var iam_instance_profile=$iam_instance_profile -var instance_initiated_shutdown_behavior=$instance_initiated_shutdown_behavior -var instance_type=$instance_type -var ipv6_address_count=$ipv6_address_count -var ipv6_addresses=$ipv6_addresses -var key_name=$key_name -var launch_template=$launch_template -var maintenance_options=$maintenance_options -var metadata_options=$metadata_options -var monitoring=$monitoring -var network_interface=$network_interface -var placement_group=$placement_group -var placement_partition_number=$placement_partition_number -var private_dns_name_options=$private_dns_name_options -var private_ips=$private_ips -var private_ip=$private_ip -var root_block_device=$root_block_device -var secondary_private_ips=$secondary_private_ips -var security_groups=$security_groups -var source_dest_check=$source_dest_check -var subnet_id=$subnet_id -var use_num_suffix=$use_num_suffix -var name=$name -var tags=$tags -var tenancy=$tenancy -var user_data=$user_data -var user_data_base64=$user_data_base64 -var user_data_replace_on_change=$user_data_replace_on_change -var volume_tags=$volume_tags -var volume_attachment_count=$volume_attachment_count -var aws_volume_attachment_device=$aws_volume_attachment_device -var volume_force_detach=$volume_force_detach -var skip_destroy=$skip_destroy -var stop_instance_before_detaching=$stop_instance_before_detaching -var ebs_encrypted=$ebs_encrypted -var final_snapshot=$final_snapshot -var ebs_iops=$ebs_iops -var multi_attach_enabled=$multi_attach_enabled -var ebs_size=$ebs_size -var snapshot_id=$snapshot_id -var outpost_arn=$outpost_arn -var ebs_type=$ebs_type -var kms_key_id=$kms_key_id -var ebs_tags=$ebs_tags -var throughput=$throughput -var createdBy=$createdBy -var project=$project -var projectComponent=$projectComponent -var env=$env --auto-approve

echo "Everything is ready...."
echo "::To destroy everything run"
echo ":: terraform destroy -auto-approve"