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

[[ -z "$region" ]] && region="us-west-1"
[[ -z "$vpc_id" ]] && echo "VPC Id is required" && exit 1
[[ -z "$reponame" ]] && reponame="kj-nestjs-eks-repo"
[[ -z "$image_tag_mutability" ]] && image_tag_mutability="IMMUTABLE"
[[ -z "$force_delete" ]] && force_delete="true"
[[ -z "$egress_from_port" ]] && egress_from_port="0"
[[ -z "$egress_to_port" ]] && egress_to_port="0"
[[ -z "$egress_protocol" ]] && egress_protocol="-1"
[[ -z "$egress_cidr_blocks" ]] && egress_cidr_blocks="[\"0.0.0.0/0\"]"
[[ -z "$sg_from_port" ]] && sg_from_port="443"
[[ -z "$sg_protocol" ]] && sg_protocol="tcp"
[[ -z "$sg_to_port" ]] && sg_to_port="443"
[[ -z "$sg_type" ]] && sg_type="ingress"
[[ -z "$cluster_name" ]] && cluster_name="K8_Cluster"
[[ -z "$node_group_name" ]] && node_group_name="k8_cluster"
[[ -z "$instance_type" ]] && instance_type="t3.medium"
[[ -z "$desired_capacity" ]] && desired_capacity="1"
[[ -z "$max_capacity" ]] && max_capacity="2"
[[ -z "$min_capacity" ]] && min_capacity="1"
[[ -z "$lbControllerRoleName" ]] && lbControllerRoleName="AmazonEKSLoadBalancerControllerRole"
[[ -z "$loadBalancerControllerPolicy" ]] && loadBalancerControllerPolicy="AWSLoadBalancerControllerIAMPolicy"
[[ -z "$origin_protocol_policy" ]] && origin_protocol_policy="http-only"
[[ -z "$http_port" ]] && http_port="80"
[[ -z "$https_port" ]] && https_port="443"
[[ -z "$origin_ssl_protocols" ]] && origin_ssl_protocols="[\"TLSv1.2\"]"
[[ -z "$enabled" ]] && enabled="true"
[[ -z "$allowed_methods" ]] && allowed_methods="[\"DELETE\",\"GET\",\"HEAD\",\"OPTIONS\",\"PATCH\",\"POST\",\"PUT\"]"
[[ -z "$cached_methods" ]] && cached_methods="[\"GET\",\"HEAD\",\"OPTIONS\"]"
[[ -z "$viewer_protocol_policy" ]] && viewer_protocol_policy="allow-all"
[[ -z "$query_string" ]] && query_string="false"
[[ -z "$forward" ]] && forward="none"
[[ -z "$restriction_type" ]] && restriction_type="none"
[[ -z "$cloudfront_default_certificate" ]] && cloudfront_default_certificate="true"
[[ -z "$namespace" ]] && namespace="default"
[[ -z "$replicas" ]] && replicas="2"

echo region : $region
echo vpc_id : $vpc_id
echo reponame : $reponame
echo image_tag_mutability : $image_tag_mutability
echo force_delete : $force_delete
echo egress_from_port : $egress_from_port
echo egress_to_port : $egress_to_port
echo egress_protocol : $egress_protocol
echo egress_cidr_blocks : $egress_cidr_blocks
echo sg_from_port : $sg_from_port
echo sg_protocol : $sg_protocol
echo sg_to_port : $sg_to_port
echo sg_type : $sg_type
echo cluster_name : $cluster_name
echo node_group_name : $node_group_name
echo instance_type : $instance_type
echo desired_capacity : $desired_capacity
echo max_capacity : $max_capacity
echo min_capacity : $min_capacity
echo lbControllerRoleName : $lbControllerRoleName
echo loadBalancerControllerPolicy : $loadBalancerControllerPolicy
echo origin_protocol_policy : $origin_protocol_policy
echo http_port : $http_port
echo https_port : $https_port
echo origin_ssl_protocols : $origin_ssl_protocols
echo enabled : $enabled
echo allowed_methods : $allowed_methods
echo cached_methods : $cached_methods
echo viewer_protocol_policy : $viewer_protocol_policy
echo query_string : $query_string
echo forward : $forward
echo restriction_type : $restriction_type
echo cloudfront_default_certificate : $cloudfront_default_certificate
echo namespace : $namespace
echo replicas : $replicas

echo "Configuring AWS..."
aws configure set aws_access_key_id $access_key && aws configure set aws_secret_access_key $secret_key && aws configure set region $region
aws eks update-kubeconfig --region $region --name "$env"_"$cluster_name"
address=$(kubectl get ingress nestjs-ingress -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")
cd infra
terraform init
terraform destroy -var region=$region -var vpc_id=$vpc_id -var reponame=$reponame -var image_tag_mutability=$image_tag_mutability -var force_delete=$force_delete -var egress_from_port=$egress_from_port \
-var egress_to_port=$egress_to_port -var egress_protocol=$egress_protocol -var egress_cidr_blocks=$egress_cidr_blocks -var sg_from_port=$sg_from_port -var sg_protocol=$sg_protocol \
-var sg_to_port=$sg_to_port -var sg_type=$sg_type -var cluster_name=$cluster_name -var node_group_name=$node_group_name -var instance_type=$instance_type \
-var desired_capacity=$desired_capacity -var max_capacity=$max_capacity -var min_capacity=$min_capacity \
-var lbControllerRoleName=$lbControllerRoleName -var accid=$accid -var oidc=$oidc -var loadBalancerControllerPolicy=$loadBalancerControllerPolicy \
-var address=$address -var origin_protocol_policy=$origin_protocol_policy -var http_port=$http_port -var https_port=$https_port -var origin_ssl_protocols=$origin_ssl_protocols \
-var enabled=$enabled -var allowed_methods=$allowed_methods -var cached_methods=$cached_methods -var viewer_protocol_policy=$viewer_protocol_policy -var restriction_type=$restriction_type \
-var cloudfront_default_certificate=$cloudfront_default_certificate \
-var env=$env -var createdBy=$createdBy -var project=$project -var projectComponent=$projectComponent \
--auto-approve

