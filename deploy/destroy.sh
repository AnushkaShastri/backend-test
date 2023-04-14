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

cd infra
echo "Azure Login..."
az login -u $username -p $password

export TF_HTTP_ADDRESS=$tf_http_address/$env
export TF_HTTP_LOCK_ADDRESS=$tf_http_lock_address/$env
export TF_HTTP_UNLOCK_ADDRESS=$tf_http_unlock_address/$env
export TF_HTTP_USERNAME=$tf_http_username
export TF_HTTP_PASSWORD=$tf_http_password

echo "Initializing..."
terraform init -reconfigure

echo "Destruction will take few minutes...."
terraform destroy -var createdBy=$createdBy -var project=$project -var projectComponent=$projectComponent --auto-approve

echo "All the resources are destroyed...."