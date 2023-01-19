for i in $@
do
var=$(echo $i | cut -f1 -d =)
declare $var=$(echo $i | cut -f2- -d =)
done

[[ -z "$access_key" ]] && echo "AWS Access Key is Required" && exit 1
[[ -z "$secret_key" ]] && echo "AWS Secret Key is Required" && exit 1

[[ -z "$env" ]] && echo "Environment is Required" && exit 1
[[ -z "$file" ]] && echo "JSON Configurations file is Required" && exit 1

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
 printf -v "$key" "%s" "$value"
done < <(jq 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' <<< ${!envObj} | sed -e 's/^"//' -e 's/"$//')

[[ -z "$region" ]] && region="us-east-1"
[[ -z "$service" ]] && service="aws-sls-backend-nodejs-lambda",
[[ -z "$serverlessOfflineHttpPort" ]] && serverlessOfflineHttpPort="3000",
[[ -z "$minimumCompressionSize" ]] && minimumCompressionSize="1024",
[[ -z "$awsNodejsConnectionReuseEnabled" ]] && awsNodejsConnectionReuseEnabled="1"

echo "Following values will be used..."

echo region : $region
echo service : $service
echo serverlessOfflineHttpPort : $serverlessOfflineHttpPort
echo minimumCompressionSize : $minimumCompressionSize
echo awsNodejsConnectionReuseEnabled : $awsNodejsConnectionReuseEnabled
echo createdBy : $createdBy
echo project : $project
echo projectComponent : $projectComponent
echo env : $env

export SERVICE=$service

echo "Configuring AWS..."
aws configure set aws_access_key_id $access_key && aws configure set aws_secret_access_key $secret_key && aws configure set default.region $region

cd app
echo "Installing Dependencies..."
npm install
echo "Destruction of resources will take few minutes...."
serverless remove --stage=$env --param="serverlessOfflineHttpPort=$serverlessOfflineHttpPort" --param="minimumCompressionSize=$minimumCompressionSize" --param="awsNodejsConnectionReuseEnabled=$awsNodejsConnectionReuseEnabled" --param="createdBy=$createdBy" --param="project=$project" --param="projectComponent=$projectComponent"
echo "All the resources are destroyed"