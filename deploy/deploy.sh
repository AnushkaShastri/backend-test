for i in $@
do
var=$(echo $i | cut -f1 -d =)
declare $var=$(echo $i | cut -f2- -d =)
done

[[ -z "$username" ]] && echo "Azure Username is Required" && exit 1
[[ -z "$password" ]] && echo "Azure Password is Required" && exit 1
[[ -z "$env" ]] && echo "Environment is Required" && exit 1
[[ -z "$file" ]] && echo "JSON Configurations file is Required" && exit 1

[[ -z "$tf_http_address" ]] && echo "Terraform Remote Backend Address is Required" && exit 1
[[ -z "$tf_http_lock_address" ]] && echo "Terraform Remote Backend Lock Address is Required" && exit 1
[[ -z "$tf_http_unlock_address" ]] && echo "Terraform Remote Backend Unlock Address is Required" && exit 1
[[ -z "$tf_http_username" ]] && echo "Terraform Remote Backend Username is Required" && exit 1
[[ -z "$tf_http_password" ]] && echo "Terraform Remote Backend Password is Required" && exit 1

[[ -z "$createdBy" ]] && echo "Created By Tag is Required" && exit 1
[[ -z "$project" ]] && echo "Project Tag is Required" && exit 1
[[ -z "$projectComponent" ]] && echo "Project Component Tag is Required" && exit 1

declare -A arr
while IFS== read key value; do
 printf -v "$key" "$value"  
 arr[$key]=$key
done < <(jq 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' $file | sed -e 's/^"//' -e 's/"$//')
envObj=${arr[$env]}
while IFS== read key value; do
 printf -v "$key" "$value"
done < <(jq 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' <<< ${!envObj} | sed -e 's/^"//' -e 's/"$//')

[[ -z "$resource_group_name" ]] && resource_group_name="resource-group-nextjs-ping"
[[ -z "$region" ]] && region="eastus2"
[[ -z "$cdn_profile_name" ]] && cdn_profile_name="cdn-profile-nextjs-ping"
[[ -z "$cdn_endpoint_name" ]] && cdn_endpoint_name="cdn-endpoint-name-nextjs-ping"
[[ -z "$storage_account_name" ]] && storage_account_name="kjnextjsstorage01"
[[ -z "$account_kind" ]] && account_kind="StorageV2"
[[ -z "$account_tier" ]] && account_tier="Standard"
[[ -z "$account_replication_type" ]] && account_replication_type="LRS"
[[ -z "$index_document" ]] && index_document="index.html"
[[ -z "$cdn_sku" ]] && cdn_sku="Standard_Verizon"
[[ -z "$origin_name" ]] && origin_name="origincdn"

echo "Following variables will be used for deployment..."
echo resource_group_name: $resource_group_name
echo region: $region
echo cdn_profile_name: $cdn_profile_name
echo cdn_endpoint_name: $cdn_endpoint_name
echo storage_account_name: $storage_account_name
echo account_kind: $account_kind
echo account_tier: $account_tier
echo account_replication_type: $account_replication_type
echo index_document: $index_document
echo cdn_sku: $cdn_sku
echo origin_name: $origin_name
echo createdBy : $createdBy
echo project : $project
echo projectComponent : $projectComponent
echo env : $env

cd app
echo "Installing dependencies..."
npm install
echo "Building your project..."
npm run build

cd ../infra

echo "Azure Login..."
az login -u $username -p $password
export AZURE_USERNAME=$username
export AZURE_PASSWORD=$password

echo "Setting terraform backend environment variables..."
export TF_HTTP_ADDRESS=$tf_http_address/$env
export TF_HTTP_LOCK_ADDRESS=$tf_http_lock_address/$env
export TF_HTTP_UNLOCK_ADDRESS=$tf_http_unlock_address/$env
export TF_HTTP_USERNAME=$tf_http_username
export TF_HTTP_PASSWORD=$tf_http_password

echo "Initializing..."
terraform init -reconfigure
echo "Setting it up will take few minutes...."
terraform apply -var resource_group_name=$resource_group_name -var region=$region -var cdn_profile_name=$cdn_profile_name -var cdn_endpoint_name=$cdn_endpoint_name -var storage_account_name=$storage_account_name -var account_kind=$account_kind -var account_tier=$account_tier -var account_replication_type=$account_replication_type -var index_document=$index_document -var cdn_sku=$cdn_sku -var origin_name=$origin_name -var createdBy=$createdBy -var project=$project -var projectComponent=$projectComponent -var env=$env --auto-approve

cd ../app
bash az storage blob upload-batch --account-name $env$storage_account_name  -s ./out -d '$web'

echo "Everything is ready...."
echo "::To destroy everything run"
echo ":: terraform destroy -auto-approve"