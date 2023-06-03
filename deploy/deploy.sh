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
[[ -z "$iam_policy_prefix" ]] && iam_policy_prefix=null
[[ -z "$iam_role_description" ]] && iam_role_description=null
[[ -z "$force_detach_policies" ]] && force_detach_policies=true
[[ -z "$max_session_duration" ]] && max_session_duration=3600
[[ -z "$iam_path" ]] && iam_path="/"
[[ -z "$iam_role_name" ]] && iam_role_name="kloudjet-node-app-iam-role"
[[ -z "$iam_role_prefix" ]] && iam_role_prefix=null
[[ -z "$iam_role_tags" ]] && iam_role_tags={}
[[ -z "$reponame" ]] && reponame="kloudjet-node-app-repo"
[[ -z "$encryption_configuration" ]] && encryption_configuration=[]
[[ -z "$ecr_force_delete" ]] && ecr_force_delete=true
[[ -z "$image_tag_mutability" ]] && image_tag_mutability="IMMUTABLE"
[[ -z "$image_scanning_configuration" ]] && image_scanning_configuration={}
[[ -z "$ecr_tags" ]] && ecr_tags={}
[[ -z "$apprunner_service_name" ]] && apprunner_service_name="kloudjet-node-app-ping"
[[ -z "$auto_deployments_enabled" ]] && auto_deployments_enabled=true
[[ -z "$image_port" ]] && image_port="8080"
[[ -z "$image_runtime_environment_secrets" ]] && image_runtime_environment_secrets={}
[[ -z "$image_runtime_environment_variables" ]] && image_runtime_environment_variables={}
[[ -z "$image_start_command" ]] && image_start_command=null
[[ -z "$image_tag" ]] && image_tag="latest"
[[ -z "$image_repository_type" ]] && image_repository_type="ECR"
[[ -z "$auto_scaling_configuration_arn" ]] && auto_scaling_configuration_arn=null
[[ -z "$apprunner_encryption_configuration" ]] && apprunner_encryption_configuration={}
[[ -z "$health_check_configuration" ]] && health_check_configuration={}
[[ -z "$instance_configuration" ]] && instance_configuration={}
[[ -z "$network_configuration" ]] && network_configuration={}
[[ -z "$observability_configuration" ]] && observability_configuration={}
[[ -z "$apprunner_tags" ]] && apprunner_tags={}

echo "Following values will be used for deployment..."

echo region : $region
echo iam_policy_name : $iam_policy_name
echo iam_policy_prefix : $iam_policy_prefix
echo iam_role_description : $iam_role_description
echo force_detach_policies : $force_detach_policies
echo max_session_duration : $max_session_duration
echo iam_path : $iam_path
echo iam_role_name : $iam_role_name
echo iam_role_prefix : $iam_role_prefix
echo iam_role_tags : $iam_role_tags
echo reponame : $reponame
echo encryption_configuration : $encryption_configuration
echo ecr_force_delete : $ecr_force_delete
echo image_tag_mutability : $image_tag_mutability
echo image_scanning_configuration : $image_scanning_configuration
echo ecr_tags : $ecr_tags
echo apprunner_service_name : $apprunner_service_name
echo auto_deployments_enabled : $auto_deployments_enabled
echo image_port : $image_port
echo image_runtime_environment_secrets : $image_runtime_environment_secrets
echo image_runtime_environment_variables : $image_runtime_environment_variables
echo image_start_command : $image_start_command
echo image_tag : $image_tag
echo image_repository_type : $image_repository_type
echo auto_scaling_configuration_arn : $auto_scaling_configuration_arn
echo apprunner_encryption_configuration : $apprunner_encryption_configuration
echo health_check_configuration : $health_check_configuration
echo instance_configuration : $instance_configuration
echo network_configuration : $network_configuration
echo observability_configuration : $observability_configuration
echo apprunner_tags : $apprunner_tags 

cd infra
echo "Configuring AWS..."
aws configure set aws_access_key_id $access_key && aws configure set aws_secret_access_key $secret_key && aws configure set default.region $region

echo "Initializing..."
terraform init -reconfigure

echo "Setting it up will take few minutes...."
terraform apply -target=aws_iam_role.role -target=aws_iam_role_policy.app_policy -target=aws_ecr_repository.app_container_ecr_repo -target=aws_ecr_repository_policy.app_container_ecr_repo_policy -var region=$region -var iam_policy_name=$iam_policy_name -var iam_policy_prefix=$iam_policy_prefix -var iam_role_description=$iam_role_description -var force_detach_policies=$force_detach_policies -var max_session_duration=$max_session_duration -var iam_path=$iam_path -var iam_role_name=$iam_role_name -var iam_role_prefix=$iam_role_prefix -var iam_role_tags=$iam_role_tags -var reponame=$reponame -var encryption_configuration=$encryption_configuration -var ecr_force_delete=$ecr_force_delete -var image_tag_mutability=$image_tag_mutability -var image_scanning_configuration=$image_scanning_configuration -var ecr_tags=$ecr_tags -var apprunner_service_name=$apprunner_service_name -var auto_deployments_enabled=$auto_deployments_enabled -var image_port=$image_port -var image_runtime_environment_secrets=$image_runtime_environment_secrets -var image_runtime_environment_variables=$image_runtime_environment_variables -var image_start_command=$image_start_command -var image_tag=$image_tag -var image_repository_type=$image_repository_type -var auto_scaling_configuration_arn=$auto_scaling_configuration_arn -var apprunner_encryption_configuration=$apprunner_encryption_configuration -var health_check_configuration=$health_check_configuration -var instance_configuration=$instance_configuration -var network_configuration=$network_configuration -var observability_configuration=$observability_configuration -var apprunner_tags=$apprunner_tags -var env=$env -var createdBy=$createdBy -var project=$project -var projectComponent=$projectComponent --auto-approve

echo "Processing....."
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $accid.dkr.ecr.$region.amazonaws.com

cd ../app
docker build -t $env-$reponame .
docker tag $env-$reponame:$image_tag $accid.dkr.ecr.$region.amazonaws.com/$env-$reponame:$image_tag
docker push $accid.dkr.ecr.$region.amazonaws.com/$env-$reponame:$image_tag

cd ../infra
terraform apply -target=aws_apprunner_service.app_node_ping -var region=$region -var iam_policy_name=$iam_policy_name -var iam_policy_prefix=$iam_policy_prefix -var iam_role_description=$iam_role_description -var force_detach_policies=$force_detach_policies -var max_session_duration=$max_session_duration -var iam_path=$iam_path -var iam_role_name=$iam_role_name -var iam_role_prefix=$iam_role_prefix -var iam_role_tags=$iam_role_tags -var reponame=$reponame -var encryption_configuration=$encryption_configuration -var ecr_force_delete=$ecr_force_delete -var image_tag_mutability=$image_tag_mutability -var image_scanning_configuration=$image_scanning_configuration -var ecr_tags=$ecr_tags -var apprunner_service_name=$apprunner_service_name -var auto_deployments_enabled=$auto_deployments_enabled -var image_port=$image_port -var image_runtime_environment_secrets=$image_runtime_environment_secrets -var image_runtime_environment_variables=$image_runtime_environment_variables -var image_start_command=$image_start_command -var image_tag=$image_tag -var image_repository_type=$image_repository_type -var auto_scaling_configuration_arn=$auto_scaling_configuration_arn -var apprunner_encryption_configuration=$apprunner_encryption_configuration -var health_check_configuration=$health_check_configuration -var instance_configuration=$instance_configuration -var network_configuration=$network_configuration -var observability_configuration=$observability_configuration -var apprunner_tags=$apprunner_tags -var env=$env -var createdBy=$createdBy -var project=$project -var projectComponent=$projectComponent --auto-approve
echo "Everything is ready...."
echo "::To destroy everything run"
echo ":: terraform destroy -auto-approve"