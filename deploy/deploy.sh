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
[[ -z "$log_bucket_name" ]] && log_bucket_name="kloudjet-react-frontend-log-bucket"
[[ -z "$deployment_bucket_name" ]] && deployment_bucket_name="kloudjet-react-frontend-deployment-bucket"
[[ -z "$log_bucket_force_destroy" ]] && log_bucket_force_destroy="true"
[[ -z "$log_bucket_access_control" ]] && log_bucket_access_control="public-read"
[[ -z "$deployment_bucket_force_destroy" ]] && deployment_bucket_force_destroy="true"
[[ -z "$deployment_bucket_access_control" ]] && deployment_bucket_access_control="public-read"
[[ -z "$index_document" ]] && index_document="index.html"
[[ -z "$error_document" ]] && error_document="error.html"
[[ -z "$origin_protocol_policy" ]] && origin_protocol_policy="http-only"
[[ -z "$http_port" ]] && http_port="80"
[[ -z "$https_port" ]] && https_port="443"
[[ -z "$origin_ssl_protocols" ]] && origin_ssl_protocols="[\"TLSv1\"]"
[[ -z "$enabled" ]] && enabled="true"
[[ -z "$is_ipv6_enabled" ]] && is_ipv6_enabled="true"
[[ -z "$default_root_object" ]] && default_root_object="index.html"
[[ -z "$include_cookies" ]] && include_cookies="false"
[[ -z "$prefix" ]] && prefix="kloudjet"
[[ -z "$error_caching_min_ttl" ]] && error_caching_min_ttl="3000"
[[ -z "$error_code" ]] && error_code="404"
[[ -z "$response_code" ]] && response_code="200"
[[ -z "$response_page_path" ]] && response_page_path="/"
[[ -z "$allowed_methods" ]] && allowed_methods="[\"DELETE\",\"GET\",\"HEAD\",\"OPTIONS\",\"PATCH\",\"POST\",\"PUT\"]"
[[ -z "$cached_methods" ]] && cached_methods="[\"GET\",\"HEAD\"]"
[[ -z "$query_string" ]] && query_string="true"
[[ -z "$forward" ]] && forward="none"
[[ -z "$viewer_protocol_policy" ]] && viewer_protocol_policy="allow-all"
[[ -z "$min_ttl" ]] && min_ttl="0"
[[ -z "$default_ttl" ]] && default_ttl="3600"
[[ -z "$max_ttl" ]] && max_ttl="86400"
[[ -z "$restriction_type" ]] && restriction_type="none"
[[ -z "$cloudfront_default_certificate" ]] && cloudfront_default_certificate="true"

echo "Following values will be used for deployment..."

echo region : $region
echo log_bucket_name : $log_bucket_name
echo deployment_bucket_name : $deployment_bucket_name
echo log_bucket_force_destroy : $log_bucket_force_destroy
echo log_bucket_access_control : $log_bucket_access_control
echo deployment_bucket_force_destroy : $deployment_bucket_force_destroy
echo deployment_bucket_access_control : $deployment_bucket_access_control
echo index_document : $index_document
echo error_document : $error_document
echo origin_protocol_policy : $origin_protocol_policy
echo http_port : $http_port
echo https_port : $https_port
echo origin_ssl_protocols : $origin_ssl_protocols
echo enabled : $enabled
echo is_ipv6_enabled : $is_ipv6_enabled
echo default_root_object : $default_root_object
echo include_cookies : $include_cookies
echo prefix : $prefix
echo error_caching_min_ttl : $error_caching_min_ttl
echo error_code : $error_code
echo response_code : $response_code
echo response_page_path : $response_page_path
echo allowed_methods : $allowed_methods
echo cached_methods : $cached_methods
echo query_string : $query_string
echo forward : $forward
echo viewer_protocol_policy : $viewer_protocol_policy
echo min_ttl : $min_ttl
echo default_ttl : $default_ttl
echo max_ttl : $max_ttl
echo restriction_type : $restriction_type
echo cloudfront_default_certificate : $cloudfront_default_certificate
echo createdBy : $createdBy
echo project : $project
echo projectComponent : $projectComponent
echo env : $env

cd app
echo "Installing Dependencies..."
npm install
# npm audit fix --force
echo "Building the project..."
npm run build
# npm run start
# npm install -g serve
# serve -s build

cd ../infra
echo "Configuring AWS..."
aws configure set aws_access_key_id $access_key && aws configure set aws_secret_access_key $secret_key && aws configure set default.region $region

echo "Initializing..."
terraform init -reconfigure

echo "Setting it up will take few minutes...."
terraform apply -var region=$region -var log_bucket_name=$log_bucket_name -var deployment_bucket_name=$deployment_bucket_name -var log_bucket_force_destroy=$log_bucket_force_destroy -var log_bucket_access_control=$log_bucket_access_control -var deployment_bucket_force_destroy=$deployment_bucket_force_destroy -var deployment_bucket_access_control=$deployment_bucket_access_control -var index_document=$index_document -var error_document=$error_document -var origin_protocol_policy=$origin_protocol_policy -var http_port=$http_port -var https_port=$https_port -var origin_ssl_protocols=$origin_ssl_protocols -var enabled=$enabled -var is_ipv6_enabled=$is_ipv6_enabled -var default_root_object=$default_root_object -var include_cookies=$include_cookies -var prefix=$prefix -var error_caching_min_ttl=$error_caching_min_ttl -var error_code=$error_code -var response_code=$response_code -var response_page_path=$response_page_path -var allowed_methods=$allowed_methods -var cached_methods=$cached_methods -var query_string=$query_string -var forward=$forward -var viewer_protocol_policy=$viewer_protocol_policy -var min_ttl=$min_ttl -var default_ttl=$default_ttl -var max_ttl=$max_ttl -var restriction_type=$restriction_type -var cloudfront_default_certificate=$cloudfront_default_certificate -var createdBy=$createdBy -var project=$project -var projectComponent=$projectComponent -var env=$env --auto-approve

aws s3 sync ../app/build s3://$env-$deployment_bucket_name

echo "Processing....."
terraform apply -var region=$region -var log_bucket_name=$log_bucket_name -var deployment_bucket_name=$deployment_bucket_name -var log_bucket_force_destroy=$log_bucket_force_destroy -var log_bucket_access_control=$log_bucket_access_control -var deployment_bucket_force_destroy=$deployment_bucket_force_destroy -var deployment_bucket_access_control=$deployment_bucket_access_control -var index_document=$index_document -var error_document=$error_document -var origin_protocol_policy=$origin_protocol_policy -var http_port=$http_port -var https_port=$https_port -var origin_ssl_protocols=$origin_ssl_protocols -var enabled=$enabled -var is_ipv6_enabled=$is_ipv6_enabled -var default_root_object=$default_root_object -var include_cookies=$include_cookies -var prefix=$prefix -var error_caching_min_ttl=$error_caching_min_ttl -var error_code=$error_code -var response_code=$response_code -var response_page_path=$response_page_path -var allowed_methods=$allowed_methods -var cached_methods=$cached_methods -var query_string=$query_string -var forward=$forward -var viewer_protocol_policy=$viewer_protocol_policy -var min_ttl=$min_ttl -var default_ttl=$default_ttl -var max_ttl=$max_ttl -var restriction_type=$restriction_type -var cloudfront_default_certificate=$cloudfront_default_certificate -var createdBy=$createdBy -var project=$project -var projectComponent=$projectComponent -var env=$env --auto-approve
echo "Everything is ready...."
echo "::To destroy everything run"
echo ":: terraform destroy -auto-approve"