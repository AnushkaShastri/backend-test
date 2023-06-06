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
[[ -z "$reponame" ]]
[[ -z "$encryption_configuration" ]]
[[ -z "$force_delete" ]]
[[ -z "$image_tag_mutability" ]]
[[ -z "$image_scanning_configuration" ]]
[[ -z "$ecr_tags" ]]
[[ -z "$iam_role_description" ]]
[[ -z "$force_detach_policies" ]]
[[ -z "$max_session_duration" ]]
[[ -z "$iam_path" ]]
[[ -z "$iam_role_name" ]]
[[ -z "$iam_role_prefix" ]]
[[ -z "$iam_role_tags" ]]
[[ -z "$sg_description" ]]
[[ -z "$sg_egress" ]]
[[ -z "$sg_ingress" ]]
[[ -z "$sg_name_prefix" ]]
[[ -z "$sg_name" ]]
[[ -z "$revoke_rules_on_delete" ]]
[[ -z "$sg_tags" ]]
[[ -z "$sg_from_port" ]]
[[ -z "$sg_protocol" ]]
[[ -z "$sg_to_port" ]]
[[ -z "$sgr_description" ]]
[[ -z "$ipv6_cidr_blocks" ]]
[[ -z "$sgr_prefix_list_ids" ]]
[[ -z "$cluster_name" ]]
[[ -z "$endpoint_private_access" ]]
[[ -z "$endpoint_public_access" ]]
[[ -z "$public_access_cidrs" ]]
[[ -z "$enabled_cluster_log_types" ]]
[[ -z "$eks_cluster_encryption_config" ]]
[[ -z "$kubernetes_network_config" ]]
[[ -z "$outpost_config" ]]
[[ -z "$cluster_tags" ]]
[[ -z "$cluster_version" ]]
[[ -z "$oidc_tags" ]]
[[ -z "$desired_capacity" ]]
[[ -z "$max_capacity" ]]
[[ -z "$min_capacity" ]]
[[ -z "$eks_ami_type" ]]
[[ -z "$capacity_type" ]]
[[ -z "$disk_size" ]]
[[ -z "$force_update_version" ]]
[[ -z "$instance_types" ]]
[[ -z "$labels" ]]
[[ -z "$launch_template" ]]
[[ -z "$node_group_name" ]]
[[ -z "$node_group_name_prefix" ]]
[[ -z "$release_version" ]]
[[ -z "$remote_access" ]]
[[ -z "$node_group_tags" ]]
[[ -z "$taint" ]]
[[ -z "$node_group_version" ]]
[[ -z "$lbControllerRoleName" ]]
[[ -z "$loadBalancerControllerPolicy" ]]
[[ -z "$loadBalancerControllerPolicyPath" ]]
[[ -z "$aliases" ]]
[[ -z "$cloudfront_comments" ]]
[[ -z "$custom_error_response" ]]
[[ -z "$allowed_methods" ]]
[[ -z "$cached_methods" ]]
[[ -z "$compress" ]]
[[ -z "$default_ttl" ]]
[[ -z "$field_level_encryption_id" ]]
[[ -z "$forwarded_values" ]]
[[ -z "$lambda_function_association" ]]
[[ -z "$function_association" ]]
[[ -z "$max_ttl" ]]
[[ -z "$min_ttl" ]]
[[ -z "$origin_request_policy_id" ]]
[[ -z "$realtime_log_config_arn" ]]
[[ -z "$response_headers_policy_id" ]]
[[ -z "$smooth_streaming" ]]
[[ -z "$trusted_key_groups" ]]
[[ -z "$trusted_signers" ]]
[[ -z "$viewer_protocol_policy" ]]
[[ -z "$default_root_object" ]]
[[ -z "$enabled" ]]
[[ -z "$is_ipv6_enabled" ]]
[[ -z "$http_version" ]]
[[ -z "$logging_config" ]]
[[ -z "$connection_attempts" ]]
[[ -z "$connection_timeout" ]]
[[ -z "$custom_origin_config" ]]
[[ -z "$custom_header" ]]
[[ -z "$origin_path" ]]
[[ -z "$origin_shield" ]]
[[ -z "$price_class" ]]
[[ -z "$restrictions" ]]
[[ -z "$cloudfront_tags" ]]
[[ -z "$viewer_certificate" ]]
[[ -z "$web_acl_id" ]]
[[ -z "$retain_on_delete" ]]
[[ -z "$wait_for_deployment" ]]
[[ -z "$namespace" ]]
[[ -z "$replicas" ]]

echo Following values will be used for deployment..
echo region : $region
echo vpc_id : $vpc_id
echo reponame : $reponame
echo encryption_configuration : $encryption_configuration
echo force_delete : $force_delete
echo image_tag_mutability : $image_tag_mutability
echo image_scanning_configuration : $image_scanning_configuration
echo ecr_tags : $ecr_tags
echo iam_role_description : $iam_role_description
echo force_detach_policies : $force_detach_policies
echo max_session_duration : $max_session_duration
echo iam_path : $iam_path
echo iam_role_name : $iam_role_name
echo iam_role_prefix : $iam_role_prefix
echo iam_role_tags : $iam_role_tags
echo sg_description : $sg_description
echo sg_egress : $sg_egress
echo sg_ingress : $sg_ingress
echo sg_name_prefix : $sg_name_prefix
echo sg_name : $sg_name
echo revoke_rules_on_delete : $revoke_rules_on_delete
echo sg_tags : $sg_tags
echo sg_from_port : $sg_from_port
echo sg_protocol : $sg_protocol
echo sg_to_port : $sg_to_port
echo sgr_description : $sgr_description
echo ipv6_cidr_blocks : $ipv6_cidr_blocks
echo sgr_prefix_list_ids : $sgr_prefix_list_ids
echo cluster_name : $cluster_name
echo endpoint_private_access : $endpoint_private_access
echo endpoint_public_access : $endpoint_public_access
echo public_access_cidrs : $public_access_cidrs
echo enabled_cluster_log_types : $enabled_cluster_log_types
echo eks_cluster_encryption_config : $eks_cluster_encryption_config
echo kubernetes_network_config : $kubernetes_network_config
echo outpost_config : $outpost_config
echo cluster_tags : $cluster_tags
echo cluster_version : $cluster_version
echo oidc_tags : $oidc_tags
echo desired_capacity : $desired_capacity
echo max_capacity : $max_capacity
echo min_capacity : $min_capacity
echo eks_ami_type : $eks_ami_type
echo capacity_type : $capacity_type
echo disk_size : $disk_size
echo force_update_version : $force_update_version
echo instance_types : $instance_types
echo labels : $labels
echo launch_template : $launch_template
echo node_group_name : $node_group_name
echo node_group_name_prefix : $node_group_name_prefix
echo release_version : $release_version
echo remote_access : $remote_access
echo node_group_tags : $node_group_tags
echo taint : $taint
echo node_group_version : $node_group_version
echo lbControllerRoleName : $lbControllerRoleName
echo loadBalancerControllerPolicy : $loadBalancerControllerPolicy
echo loadBalancerControllerPolicyPath : $loadBalancerControllerPolicyPath
echo aliases : $aliases
echo cloudfront_comments : $cloudfront_comments
echo custom_error_response : $custom_error_response
echo allowed_methods : $allowed_methods
echo cached_methods : $cached_methods
echo compress : $compress
echo default_ttl : $default_ttl
echo field_level_encryption_id : $field_level_encryption_id
echo forwarded_values : $forwarded_values
echo lambda_function_association : $lambda_function_association
echo function_association : $function_association
echo max_ttl : $max_ttl
echo min_ttl : $min_ttl
echo origin_request_policy_id : $origin_request_policy_id
echo realtime_log_config_arn : $realtime_log_config_arn
echo response_headers_policy_id : $response_headers_policy_id
echo smooth_streaming : $smooth_streaming
echo trusted_key_groups : $trusted_key_groups
echo trusted_signers : $trusted_signers
echo viewer_protocol_policy : $viewer_protocol_policy
echo default_root_object : $default_root_object
echo enabled : $enabled
echo is_ipv6_enabled : $is_ipv6_enabled
echo http_version : $http_version
echo logging_config : $logging_config
echo connection_attempts : $connection_attempts
echo connection_timeout : $connection_timeout
echo custom_origin_config : $custom_origin_config
echo custom_header : $custom_header
echo origin_path : $origin_path
echo origin_shield : $origin_shield
echo price_class : $price_class
echo restrictions : $restrictions
echo cloudfront_tags : $cloudfront_tags
echo viewer_certificate : $viewer_certificate
echo web_acl_id : $web_acl_id
echo retain_on_delete : $retain_on_delete
echo wait_for_deployment : $wait_for_deployment
echo namespace : $namespace
echo replicas : $replicas

echo "Configuring AWS..."
aws configure set aws_access_key_id $access_key && aws configure set aws_secret_access_key $secret_key && aws configure set region $region

cd infra
terraform init
terraform apply -target=aws_ecr_repository.app_container_ecr_repo -target=aws_ecr_repository_policy.app_container_ecr_repo_policy -target=aws_iam_role.k8_cluster -target=aws_iam_role_policy_attachment.k8_cluster-AmazonEKSClusterPolicy -target=aws_iam_role_policy_attachment.k8_cluster-AmazonEKSVPCResourceController -target=aws_security_group.k8_cluster -target=aws_security_group_rule.k8_cluster-ingress-workstation-https -target=aws_eks_cluster.k8_cluster -target=aws_iam_openid_connect_provider.cluster -target=aws_iam_role.k8_cluster-node -target=aws_iam_role_policy_attachment.k8_cluster-node-AmazonEKSWorkerNodePolicy -target=aws_iam_role_policy_attachment.k8_cluster-node-AmazonEKS_CNI_Policy -target=aws_iam_role_policy_attachment.k8_cluster-node-AmazonEC2ContainerRegistryReadOnly -target=aws_eks_node_group.k8_cluster -var createdBy=$createdBy -var project=$project -var projectComponent=$projectComponent -var env=$env -var region=$region -var vpc_id=$vpc_id -var reponame=$reponame -var encryption_configuration=$encryption_configuration -var force_delete=$force_delete -var image_tag_mutability=$image_tag_mutability -var image_scanning_configuration=$image_scanning_configuration -var ecr_tags=$ecr_tags -var iam_role_description=$iam_role_description -var force_detach_policies=$force_detach_policies -var max_session_duration=$max_session_duration -var iam_path=$iam_path -var iam_role_name=$iam_role_name -var iam_role_prefix=$iam_role_prefix -var iam_role_tags=$iam_role_tags -var sg_description=$sg_description -var sg_egress=$sg_egress -var sg_ingress=$sg_ingress -var sg_name_prefix=$sg_name_prefix -var sg_name=$sg_name -var revoke_rules_on_delete=$revoke_rules_on_delete -var sg_tags=$sg_tags -var sg_from_port=$sg_from_port -var sg_protocol=$sg_protocol -var sg_to_port=$sg_to_port -var sgr_description=$sgr_description -var ipv6_cidr_blocks=$ipv6_cidr_blocks -var sgr_prefix_list_ids=$sgr_prefix_list_ids -var cluster_name=$cluster_name -var endpoint_private_access=$endpoint_private_access -var endpoint_public_access=$endpoint_public_access -var public_access_cidrs=$public_access_cidrs -var enabled_cluster_log_types=$enabled_cluster_log_types -var eks_cluster_encryption_config=$eks_cluster_encryption_config -var kubernetes_network_config=$kubernetes_network_config -var outpost_config=$outpost_config -var cluster_tags=$cluster_tags -var cluster_version=$cluster_version -var oidc_tags=$oidc_tags -var desired_capacity=$desired_capacity -var max_capacity=$max_capacity -var min_capacity=$min_capacity -var eks_ami_type=$eks_ami_type -var capacity_type=$capacity_type -var disk_size=$disk_size -var force_update_version=$force_update_version -var instance_types=$instance_types -var labels=$labels -var launch_template=$launch_template -var node_group_name=$node_group_name -var node_group_name_prefix=$node_group_name_prefix -var release_version=$release_version -var remote_access=$remote_access -var node_group_tags=$node_group_tags -var taint=$taint -var node_group_version=$node_group_version -var lbControllerRoleName=$lbControllerRoleName -var accid=$accid -var loadBalancerControllerPolicy=$loadBalancerControllerPolicy -var loadBalancerControllerPolicyPath=$loadBalancerControllerPolicyPath -var aliases=$aliases -var cloudfront_comments=$cloudfront_comments -var custom_error_response=$custom_error_response -var allowed_methods=$allowed_methods -var cached_methods=$cached_methods -var compress=$compress -var default_ttl=$default_ttl -var field_level_encryption_id=$field_level_encryption_id -var forwarded_values=$forwarded_values -var lambda_function_association=$lambda_function_association -var function_association=$function_association -var max_ttl=$max_ttl -var min_ttl=$min_ttl -var origin_request_policy_id=$origin_request_policy_id -var realtime_log_config_arn=$realtime_log_config_arn -var response_headers_policy_id=$response_headers_policy_id -var smooth_streaming=$smooth_streaming -var trusted_key_groups=$trusted_key_groups -var trusted_signers=$trusted_signers -var viewer_protocol_policy=$viewer_protocol_policy -var default_root_object=$default_root_object -var enabled=$enabled -var is_ipv6_enabled=$is_ipv6_enabled -var http_version=$http_version -var logging_config=$logging_config -var connection_attempts=$connection_attempts -var connection_timeout=$connection_timeout -var custom_origin_config=$custom_origin_config -var custom_header=$custom_header -var origin_path=$origin_path -var origin_shield=$origin_shield -var price_class=$price_class -var restrictions=$restrictions -var cloudfront_tags=$cloudfront_tags -var viewer_certificate=$viewer_certificate -var web_acl_id=$web_acl_id -var retain_on_delete=$retain_on_delete -var wait_for_deployment=$wait_for_deployment --auto-approve
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $accid.dkr.ecr.$region.amazonaws.com
cd ../app
docker build -t $env-$reponame . 
docker tag $env-$reponame:latest $accid.dkr.ecr.$region.amazonaws.com/$env-$reponame:latest
docker push $accid.dkr.ecr.$region.amazonaws.com/$env-$reponame:latest

oidc=$(aws eks describe-cluster --name "$env"_"$cluster_name" --region $region --query "cluster.identity.oidc.issuer" --output text)
oidc=$(echo $oidc | xargs | awk -F '://' '{print $2}' )

cd ../infra
terraform apply -target=aws_iam_role.AmazonEKSLoadBalancerControllerRole -target=aws_iam_policy.load_balancer_controller -target=aws_iam_role_policy_attachment.attach -var createdBy=$createdBy -var project=$project -var projectComponent=$projectComponent -var env=$env -var region=$region -var vpc_id=$vpc_id -var reponame=$reponame -var encryption_configuration=$encryption_configuration -var force_delete=$force_delete -var image_tag_mutability=$image_tag_mutability -var image_scanning_configuration=$image_scanning_configuration -var ecr_tags=$ecr_tags -var iam_role_description=$iam_role_description -var force_detach_policies=$force_detach_policies -var max_session_duration=$max_session_duration -var iam_path=$iam_path -var iam_role_name=$iam_role_name -var iam_role_prefix=$iam_role_prefix -var iam_role_tags=$iam_role_tags -var sg_description=$sg_description -var sg_egress=$sg_egress -var sg_ingress=$sg_ingress -var sg_name_prefix=$sg_name_prefix -var sg_name=$sg_name -var revoke_rules_on_delete=$revoke_rules_on_delete -var sg_tags=$sg_tags -var sg_from_port=$sg_from_port -var sg_protocol=$sg_protocol -var sg_to_port=$sg_to_port -var sgr_description=$sgr_description -var ipv6_cidr_blocks=$ipv6_cidr_blocks -var sgr_prefix_list_ids=$sgr_prefix_list_ids -var cluster_name=$cluster_name -var endpoint_private_access=$endpoint_private_access -var endpoint_public_access=$endpoint_public_access -var public_access_cidrs=$public_access_cidrs -var enabled_cluster_log_types=$enabled_cluster_log_types -var eks_cluster_encryption_config=$eks_cluster_encryption_config -var kubernetes_network_config=$kubernetes_network_config -var outpost_config=$outpost_config -var cluster_tags=$cluster_tags -var cluster_version=$cluster_version -var oidc_tags=$oidc_tags -var desired_capacity=$desired_capacity -var max_capacity=$max_capacity -var min_capacity=$min_capacity -var eks_ami_type=$eks_ami_type -var capacity_type=$capacity_type -var disk_size=$disk_size -var force_update_version=$force_update_version -var instance_types=$instance_types -var labels=$labels -var launch_template=$launch_template -var node_group_name=$node_group_name -var node_group_name_prefix=$node_group_name_prefix -var release_version=$release_version -var remote_access=$remote_access -var node_group_tags=$node_group_tags -var taint=$taint -var node_group_version=$node_group_version -var lbControllerRoleName=$lbControllerRoleName -var accid=$accid -var oidc=$oidc -var loadBalancerControllerPolicy=$loadBalancerControllerPolicy -var loadBalancerControllerPolicyPath=$loadBalancerControllerPolicyPath -var aliases=$aliases -var cloudfront_comments=$cloudfront_comments -var custom_error_response=$custom_error_response -var allowed_methods=$allowed_methods -var cached_methods=$cached_methods -var compress=$compress -var default_ttl=$default_ttl -var field_level_encryption_id=$field_level_encryption_id -var forwarded_values=$forwarded_values -var lambda_function_association=$lambda_function_association -var function_association=$function_association -var max_ttl=$max_ttl -var min_ttl=$min_ttl -var origin_request_policy_id=$origin_request_policy_id -var realtime_log_config_arn=$realtime_log_config_arn -var response_headers_policy_id=$response_headers_policy_id -var smooth_streaming=$smooth_streaming -var trusted_key_groups=$trusted_key_groups -var trusted_signers=$trusted_signers -var viewer_protocol_policy=$viewer_protocol_policy -var default_root_object=$default_root_object -var enabled=$enabled -var is_ipv6_enabled=$is_ipv6_enabled -var http_version=$http_version -var logging_config=$logging_config -var connection_attempts=$connection_attempts -var connection_timeout=$connection_timeout -var custom_origin_config=$custom_origin_config -var custom_header=$custom_header -var origin_path=$origin_path -var origin_shield=$origin_shield -var price_class=$price_class -var restrictions=$restrictions -var cloudfront_tags=$cloudfront_tags -var viewer_certificate=$viewer_certificate -var web_acl_id=$web_acl_id -var retain_on_delete=$retain_on_delete -var wait_for_deployment=$wait_for_deployment --auto-approve
cat > aws-load-balancer-controller-service-account.yaml << EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/name: aws-load-balancer-controller
  name: aws-load-balancer-controller
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::${accid}:role/${env}-${lbControllerRoleName}
EOF

[ ! -d "$HOME/.kube" ] && mkdir $HOME/.kube
aws eks update-kubeconfig --region $region --name "$env"_"$cluster_name"

export KUBECONFIG=$HOME/.kube/config

kubectl apply -f aws-load-balancer-controller-service-account.yaml

helm repo add eks https://aws.github.io/eks-charts

helm repo update

helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName="$env"_"$cluster_name" \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller

cd ../deploy

sed -i "s/image: .*/image: ${accid}.dkr.ecr.${region}.amazonaws.com\/${env}-${reponame}:latest/" deployment.yaml
sed -i "s/replicas: .*/replicas: ${replicas}/" deployment.yaml

#create namespace if does not exist
ns_exists=$(kubectl get ns | grep -w $namespace)

if [[ -z "$ns_exists" ]]; then 
kubectl create namespace $namespace
else
echo "Namespace already exists"
fi

kubectl apply -f deployment.yaml -n $namespace
kubectl apply -f service.yaml -n $namespace 
kubectl apply -f ingress.yaml -n $namespace
sleep 60
address=$(kubectl get ingress nodejs-ingress -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

cd ../infra
terraform apply -target=aws_cloudfront_distribution.distribution -var createdBy=$createdBy -var project=$project -var projectComponent=$projectComponent -var env=$env -var region=$region -var vpc_id=$vpc_id -var reponame=$reponame -var encryption_configuration=$encryption_configuration -var force_delete=$force_delete -var image_tag_mutability=$image_tag_mutability -var image_scanning_configuration=$image_scanning_configuration -var ecr_tags=$ecr_tags -var iam_role_description=$iam_role_description -var force_detach_policies=$force_detach_policies -var max_session_duration=$max_session_duration -var iam_path=$iam_path -var iam_role_name=$iam_role_name -var iam_role_prefix=$iam_role_prefix -var iam_role_tags=$iam_role_tags -var sg_description=$sg_description -var sg_egress=$sg_egress -var sg_ingress=$sg_ingress -var sg_name_prefix=$sg_name_prefix -var sg_name=$sg_name -var revoke_rules_on_delete=$revoke_rules_on_delete -var sg_tags=$sg_tags -var sg_from_port=$sg_from_port -var sg_protocol=$sg_protocol -var sg_to_port=$sg_to_port -var sgr_description=$sgr_description -var ipv6_cidr_blocks=$ipv6_cidr_blocks -var sgr_prefix_list_ids=$sgr_prefix_list_ids -var cluster_name=$cluster_name -var endpoint_private_access=$endpoint_private_access -var endpoint_public_access=$endpoint_public_access -var public_access_cidrs=$public_access_cidrs -var enabled_cluster_log_types=$enabled_cluster_log_types -var eks_cluster_encryption_config=$eks_cluster_encryption_config -var kubernetes_network_config=$kubernetes_network_config -var outpost_config=$outpost_config -var cluster_tags=$cluster_tags -var cluster_version=$cluster_version -var oidc_tags=$oidc_tags -var desired_capacity=$desired_capacity -var max_capacity=$max_capacity -var min_capacity=$min_capacity -var eks_ami_type=$eks_ami_type -var capacity_type=$capacity_type -var disk_size=$disk_size -var force_update_version=$force_update_version -var instance_types=$instance_types -var labels=$labels -var launch_template=$launch_template -var node_group_name=$node_group_name -var node_group_name_prefix=$node_group_name_prefix -var release_version=$release_version -var remote_access=$remote_access -var node_group_tags=$node_group_tags -var taint=$taint -var node_group_version=$node_group_version -var lbControllerRoleName=$lbControllerRoleName -var accid=$accid -var oidc=$oidc -var loadBalancerControllerPolicy=$loadBalancerControllerPolicy -var loadBalancerControllerPolicyPath=$loadBalancerControllerPolicyPath -var aliases=$aliases -var cloudfront_comments=$cloudfront_comments -var custom_error_response=$custom_error_response -var allowed_methods=$allowed_methods -var cached_methods=$cached_methods -var compress=$compress -var default_ttl=$default_ttl -var field_level_encryption_id=$field_level_encryption_id -var forwarded_values=$forwarded_values -var lambda_function_association=$lambda_function_association -var function_association=$function_association -var max_ttl=$max_ttl -var min_ttl=$min_ttl -var origin_request_policy_id=$origin_request_policy_id -var realtime_log_config_arn=$realtime_log_config_arn -var response_headers_policy_id=$response_headers_policy_id -var smooth_streaming=$smooth_streaming -var address=$address -var trusted_key_groups=$trusted_key_groups -var trusted_signers=$trusted_signers -var viewer_protocol_policy=$viewer_protocol_policy -var default_root_object=$default_root_object -var enabled=$enabled -var is_ipv6_enabled=$is_ipv6_enabled -var http_version=$http_version -var logging_config=$logging_config -var connection_attempts=$connection_attempts -var connection_timeout=$connection_timeout -var custom_origin_config=$custom_origin_config -var custom_header=$custom_header -var origin_path=$origin_path -var origin_shield=$origin_shield -var price_class=$price_class -var restrictions=$restrictions -var cloudfront_tags=$cloudfront_tags -var viewer_certificate=$viewer_certificate -var web_acl_id=$web_acl_id -var retain_on_delete=$retain_on_delete -var wait_for_deployment=$wait_for_deployment --auto-approve