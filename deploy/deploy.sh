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

echo "Following values will be used for deployment..."

echo region : $region
echo service : $service
echo awsNodejsConnectionReuseEnabled : $awsNodejsConnectionReuseEnabled

export SERVICE=$service
# export SERVERLESS_OFFLINE_HTTP_PORT=$serverlessOfflineHttpPort
# export MINIMUM_COMPRESSION_SIZE=$minimumCompressionSize
# export AWS_NODEJS_CONNECTION_REUSE_ENABLED=$awsNodejsConnectionReuseEnabled

echo "Configuring AWS..."
aws configure set aws_access_key_id $access_key && aws configure set aws_secret_access_key $secret_key && aws configure set default.region $region

cd app
echo "Installing Dependencies..."
npm install
echo "Setting it up will take few minutes...."
serverless deploy --stage=$env --param="awsNodejsConnectionReuseEnabled=$awsNodejsConnectionReuseEnabled" --param="minimumCompressionSize=$minimumCompressionSize"