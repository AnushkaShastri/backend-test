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

[[ -z "$repoName" ]] && repoName="kloudjet-python-app-repo"
[[ -z "$region" ]] && region="us-east-1"
[[ -z "$imageTag" ]] && imageTag="latest"
[[ -z "$policy_name" ]] && policy_name="python-apprunner-iam-policy"
[[ -z "$iam_role_name" ]] && iam_role_name="python-apprunner-iam-role"
[[ -z "$image_tag_mutability" ]] && image_tag_mutability="IMMUTABLE"
[[ -z "$service_name" ]] && service_name="python-apprunner-ping"
[[ -z "$port" ]] && port="8080"
[[ -z "$image_repository_type" ]] && image_repository_type="ECR"
[[ -z "$auto_deployments_enabled" ]] && auto_deployments_enabled="true"
[[ -z "$tags" ]] && tags="{\"Name\"=\"Backend-apprunner-service\"}"
[[ -z "$force_delete" ]] && force_delete="true"

echo "Following variable values will be used for deployment..."

echo "repoName : $repoName"
echo "region : $region"
echo "imageTag : $imageTag"
echo "policy_name : $policy_name"
echo "iam_role_name : $iam_role_name"
echo "image_tag_mutability : $image_tag_mutability"
echo "service_name : $service_name"
echo "port : $port"
echo "image_repository_type : $image_repository_type"
echo "auto_deployments_enabled : $auto_deployments_enabled"
echo "tags : $tags"
echo "env : $env"
echo "createdBy : $createdBy"
echo "project : $project"
echo "projectComponent : $projectComponent"
echo "force_delete : $force_delete"


echo "Configuring AWS..."
aws configure set aws_access_key_id $access_key && aws configure set aws_secret_access_key $secret_key

cd ./infra

echo "Initializing"

terraform init -reconfigure


terraform destroy -var region="$region" -var repoName="$repoName" -var imageTag="$imageTag" -var policy_name="$policy_name" -var iam_role_name="$iam_role_name" -var image_tag_mutability="$image_tag_mutability" -var service_name="$service_name" -var port="$port" -var image_repository_type="$image_repository_type" -var auto_deployments_enabled="$auto_deployments_enabled" -var tags="$tags" -var force_delete="$force_delete" -var env="$env" -var createdBy="$createdBy" -var project="$project" -var projectComponent="$projectComponent" -target=aws_iam_role_policy.test_policy -target=aws_iam_role.role -target=aws_ecr_repository.app_container_ecr_repo -target=aws_ecr_repository_policy.app_container_ecr_repo_policy -auto-approve

terraform destroy -var region="$region" -var repoName="$repoName" -var imageTag="$imageTag" -var policy_name="$policy_name" -var iam_role_name="$iam_role_name" -var image_tag_mutability="$image_tag_mutability" -var service_name="$service_name" -var port="$port" -var image_repository_type="$image_repository_type" -var auto_deployments_enabled="$auto_deployments_enabled" -var tags="$tags" -var force_delete="$force_delete" -var env="$env" -var createdBy="$createdBy" -var project="$project" -var projectComponent="$projectComponent" -target=aws_apprunner_service.app_python_ping -auto-approve




