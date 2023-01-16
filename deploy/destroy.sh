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
[[ -z "$iam_policy_name" ]] && iam_policy_name="kloudjet-node-app-iam-policy" 
[[ -z "$iam_role_name" ]] && iam_role_name="kloudjet-node-app-iam-role" 
[[ -z "$repo_name" ]] && repo_name="kloudjet-node-app-repo" 
[[ -z "$image_tag_mutability" ]] && image_tag_mutability="IMMUTABLE" 
[[ -z "$force_delete" ]] && force_delete="true"
[[ -z "$apprunner_service_name" ]] && apprunner_service_name="kloudjet-node-app-ping" 
[[ -z "$port" ]] && port="8080" 
[[ -z "$auto_deployments_enabled" ]] && auto_deployments_enabled="true" 

echo "Following values will be used..."

echo region : $region 
echo iam_policy_name : $iam_policy_name
echo iam_role_name : $iam_role_name
echo repo_name : $repo_name
echo image_tag_mutability : $image_tag_mutability
echo force_delete : $force_delete
echo apprunner_service_name : $apprunner_service_name
echo port : $port 
echo auto_deployments_enabled : $auto_deployments_enabled 

cd infra
echo "Configuring AWS..."
aws configure set aws_access_key_id $access_key && aws configure set aws_secret_access_key $secret_key && aws configure set default.region $region

echo "Initializing..."
terraform init -reconfigure 

echo "Destruction will take few minutes...."
terraform destroy -var region=$region -var iam_policy_name=$iam_policy_name -var iam_role_name=$iam_role_name -var repo_name=$repo_name -var image_tag_mutability=$image_tag_mutability -var force_delete=$force_delete -var apprunner_service_name=$apprunner_service_name -var port=$port -var image_tag=$image_tag -var auto_deployments_enabled=$auto_deployments_enabled -var env=$env -var createdBy=$createdBy -var project=$project -var projectComponent=$projectComponent -auto-approve
echo "All the resources are destroyed...."