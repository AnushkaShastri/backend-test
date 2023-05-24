for i in $@
do
var=$(echo $i | cut -f1 -d =)
declare $var=$(echo $i | cut -f2- -d =)
done

[[ -z "$access_key" ]] && echo "AWS Access Key is Required" && exit 1
[[ -z "$secret_key" ]] && echo "AWS Secret Key is Required" && exit 1
[[ -z "$accid" ]] && echo "AWS Account ID is Required" && exit 1

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
[[ -z "$iam_policy_name" ]] && iam_policy_name="kloudjet-node-app-iam-policy"
[[ -z "$iam_policy_prefix" ]] && iam_policy_prefix="null"
[[ -z "$iam_role_description" ]] && iam_role_description="null"
[[ -z "$iam_role_name" ]] && iam_role_name="kloudjet-node-app-iam-role"
[[ -z "$force_detach_policies" ]] && force_detach_policies="true"
[[ -z "$inline_policy" ]] && inline_policy="null"
[[ -z "$managed_policy_arns" ]] && managed_policy_arns="null"
[[ -z "$max_session_duration" ]] && max_session_duration="1"
[[ -z "$iam_role_prefix" ]] && iam_role_prefix="null"
[[ -z "$iam_role_path" ]] && iam_role_path="null"
[[ -z "$permissions_boundary" ]] && permissions_boundary="null"
[[ -z "$iam_role_tags" ]] && iam_role_tags="{}"
[[ -z "$reponame" ]] && reponame="kloudjet-node-app-repo"
[[ -z "$encryption_type" ]] && encryption_type="null"
[[ -z "$kms_key" ]] && kms_key="null"
[[ -z "$force_delete" ]] && force_delete="true"
[[ -z "$image_tag_mutability" ]] && image_tag_mutability="IMMUTABLE"
[[ -z "$scan_on_push" ]] && scan_on_push="false"
[[ -z "$ecr_tags" ]] && ecr_tags="{}"
[[ -z "$apprunner_service_name" ]] && apprunner_service_name="kloudjet-node-app-ping"
[[ -z "$connection_arn" ]] && connection_arn="null"
[[ -z "$auto_deployments_enabled" ]] && auto_deployments_enabled="false"
[[ -z "$code_repository" ]] && code_repository="false"
[[ -z "$build_command" ]] && build_command="null"
[[ -z "$apprunner_port" ]] && apprunner_port="null"
[[ -z "$runtime" ]] && runtime="null"
[[ -z "$runtime_environment_secrets" ]] && runtime_environment_secrets="{}"
[[ -z "$runtime_environment_variables" ]] && runtime_environment_variables="{}"
[[ -z "$start_command" ]] && start_command="null"
[[ -z "$configuration_source" ]] && configuration_source="null"
[[ -z "$repository_url" ]] && repository_url="null"
[[ -z "$source_code_type" ]] && source_code_type="null"
[[ -z "$source_code_value" ]] && source_code_value="null"
[[ -z "$image_repository" ]] && image_repository="true"
[[ -z "$port" ]] && port="8080"
[[ -z "$image_runtime_environment_secrets" ]] && image_runtime_environment_secrets="{}"
[[ -z "$image_runtime_environment_variables" ]] && image_runtime_environment_variables="{}"
[[ -z "$image_start_command" ]] && image_start_command="null"
[[ -z "$image_tag" ]] && image_tag="latest"
[[ -z "$image_repository_type" ]] && image_repository_type="ECR"
[[ -z "$auto_scaling_configuration_arn" ]] && auto_scaling_configuration_arn="null"
[[ -z "$encryption_kms_key" ]] && encryption_kms_key=""
[[ -z "$healthy_threshold" ]] && healthy_threshold="1"
[[ -z "$interval" ]] && interval="5"
[[ -z "$health_path" ]] && health_path="/"
[[ -z "$health_protocol" ]] && health_protocol="TCP"
[[ -z "$health_timeout" ]] && health_timeout="2"
[[ -z "$unhealthy_threshold" ]] && unhealthy_threshold="5"
[[ -z "$instance_cpu" ]] && instance_cpu="1024"
[[ -z "$instance_role_arn" ]] && instance_role_arn="null"
[[ -z "$instance_memory" ]] && instance_memory="2048"
[[ -z "$is_publicly_accessible" ]] && is_publicly_accessible="true"
[[ -z "$egress_type" ]] && egress_type="DEFAULT"
[[ -z "$vpc_connector_arn" ]] && vpc_connector_arn="null"
[[ -z "$observability_enabled" ]] && observability_enabled="false"
[[ -z "$observability_configuration_arn" ]] && observability_configuration_arn="null"
[[ -z "$apprunner_tags" ]] && apprunner_tags="{}"

echo "Following values will be used for deployment..."

echo region : $region
echo iam_policy_name : $iam_policy_name
echo iam_policy_prefix : $iam_policy_prefix
echo iam_role_description : $iam_role_description
echo iam_role_name : $iam_role_name
echo force_detach_policies : $force_detach_policies
echo inline_policy : $inline_policy
echo managed_policy_arns : $managed_policy_arns
echo max_session_duration : $max_session_duration
echo iam_role_prefix : $iam_role_prefix
echo iam_role_path : $iam_role_path
echo permissions_boundary : $permissions_boundary
echo iam_role_tags : $iam_role_tags
echo reponame : $reponame
echo encryption_type : $encryption_type
echo kms_key : $kms_key
echo force_delete : $force_delete
echo image_tag_mutability : $image_tag_mutability
echo scan_on_push : $scan_on_push
echo ecr_tags : $ecr_tags
echo apprunner_service_name : $apprunner_service_name
echo connection_arn : $connection_arn
echo auto_deployments_enabled : $auto_deployments_enabled
echo code_repository : $code_repository
echo build_command : $build_command
echo apprunner_port : $apprunner_port
echo runtime : $runtime
echo runtime_environment_secrets : $runtime_environment_secrets
echo runtime_environment_variables : $runtime_environment_variables
echo start_command : $start_command
echo configuration_source : $configuration_source
echo repository_url : $repository_url
echo source_code_type : $source_code_type
echo source_code_value : $source_code_value
echo image_repository : $image_repository
echo port : $port
echo image_runtime_environment_secrets : $image_runtime_environment_secrets
echo image_runtime_environment_variables : $image_runtime_environment_variables
echo image_start_command : $image_start_command
echo image_tag : $image_tag
echo image_repository_type : $image_repository_type
echo auto_scaling_configuration_arn : $auto_scaling_configuration_arn
echo encryption_kms_key : $encryption_kms_key
echo healthy_threshold : $healthy_threshold
echo interval : $interval
echo health_path : $health_path
echo health_protocol : $health_protocol
echo health_timeout : $health_timeout
echo unhealthy_threshold : $unhealthy_threshold
echo instance_cpu : $instance_cpu
echo instance_role_arn : $instance_role_arn
echo instance_memory : $instance_memory
echo is_publicly_accessible : $is_publicly_accessible
echo egress_type : $egress_type
echo vpc_connector_arn : $vpc_connector_arn
echo observability_enabled : $observability_enabled
echo observability_configuration_arn : $observability_configuration_arn
echo apprunner_tags : $apprunner_tags 

cd infra
echo "Configuring AWS..."
aws configure set aws_access_key_id $access_key && aws configure set aws_secret_access_key $secret_key && aws configure set default.region $region

echo "Initializing..."
terraform init -reconfigure

echo "Setting it up will take few minutes...."
terraform apply -target=aws_iam_role.role -target=aws_iam_role_policy.app_policy -target=aws_ecr_repository.app_container_ecr_repo -target=aws_ecr_repository_policy.app_container_ecr_repo_policy -var region=$region -var iam_policy_name=$iam_policy_name -var iam_policy_prefix=$iam_policy_prefix -var iam_role_description=$iam_role_description -var iam_role_name=$iam_role_name -var force_detach_policies=$force_detach_policies -var inline_policy=$inline_policy -var managed_policy_arns=$managed_policy_arns -var max_session_duration=$max_session_duration -var iam_role_prefix=$iam_role_prefix -var iam_role_path=$iam_role_path -var permissions_boundary=$permissions_boundary -var iam_role_tags=$iam_role_tags -var reponame=$reponame -var encryption_type=$encryption_type -var kms_key=$kms_key -var force_delete=$force_delete -var image_tag_mutability=$image_tag_mutability -var scan_on_push=$scan_on_push -var ecr_tags=$ecr_tags -var env=$env -var createdBy=$createdBy -var project=$project -var projectComponent=$projectComponent -auto-approve

echo "Processing....."
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $accid.dkr.ecr.$region.amazonaws.com

cd ../app
docker build -t $env-$reponame .
docker tag $env-$reponame:$image_tag $accid.dkr.ecr.$region.amazonaws.com/$env-$reponame:$image_tag
docker push $accid.dkr.ecr.$region.amazonaws.com/$env-$reponame:$image_tag

cd ../infra
terraform apply -target=aws_apprunner_service.app_node_ping -var region=$region -var iam_policy_name=$iam_policy_name -var iam_policy_prefix=$iam_policy_prefix -var iam_role_description=$iam_role_description -var iam_role_name=$iam_role_name -var force_detach_policies=$force_detach_policies -var inline_policy=$inline_policy -var managed_policy_arns=$managed_policy_arns -var max_session_duration=$max_session_duration -var iam_role_prefix=$iam_role_prefix -var iam_role_path=$iam_role_path -var permissions_boundary=$permissions_boundary -var iam_role_tags=$iam_role_tags -var reponame=$reponame -var encryption_type=$encryption_type -var kms_key=$kms_key -var force_delete=$force_delete -var image_tag_mutability=$image_tag_mutability -var scan_on_push=$scan_on_push -var ecr_tags=$ecr_tags -var apprunner_service_name=$apprunner_service_name -var connection_arn=$connection_arn -var auto_deployments_enabled=$auto_deployments_enabled -var code_repository=$code_repository -var build_command=$build_command -var apprunner_port=$apprunner_port -var runtime=$runtime -var runtime_environment_secrets=$runtime_environment_secrets -var runtime_environment_variables=$runtime_environment_variables -var start_command=$start_command -var configuration_source=$configuration_source -var repository_url=$repository_url -var source_code_type=$source_code_type -var source_code_value=$source_code_value -var image_repository=$image_repository -var port=$port -var image_runtime_environment_secrets=$image_runtime_environment_secrets -var image_runtime_environment_variables=$image_runtime_environment_variables -var image_start_command=$image_start_command -var image_tag=$image_tag -var image_repository_type=$image_repository_type -var auto_scaling_configuration_arn=$auto_scaling_configuration_arn -var encryption_kms_key=$encryption_kms_key -var healthy_threshold=$healthy_threshold -var interval=$interval -var health_path=$health_path -var health_protocol=$health_protocol -var health_timeout=$health_timeout -var unhealthy_threshold=$unhealthy_threshold -var instance_cpu=$instance_cpu -var instance_role_arn=$instance_role_arn -var instance_memory=$instance_memory -var is_publicly_accessible=$is_publicly_accessible -var egress_type=$egress_type -var vpc_connector_arn=$vpc_connector_arn -var observability_enabled=$observability_enabled -var observability_configuration_arn=$observability_configuration_arn -var apprunner_tags=$apprunner_tags -var env=$env -var createdBy=$createdBy -var project=$project -var projectComponent=$projectComponent -auto-approve

echo "Everything is ready...."
echo "::To destroy everything run"
echo ":: terraform destroy -auto-approve"