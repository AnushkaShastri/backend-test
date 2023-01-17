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
[[ -z "$reponame" ]] && reponame="kloudjet-nodejs-fargate-repo"
[[ -z "$image_tag_mutability" ]] && image_tag_mutability="IMMUTABLE"
[[ -z "$force_delete" ]] && force_delete="true"
[[ -z "$clustername" ]] && clustername="kloudjet-nodejs-fargate-cluster"
[[ -z "$ecs_task_family" ]] && ecs_task_family="kloudjet_ecs_task"
[[ -z "$requires_compatibilities" ]] && requires_compatibilities="[\"FARGATE\"]"
[[ -z "$network_mode" ]] && network_mode="awsvpc"
[[ -z "$memory" ]] && memory="512"
[[ -z "$cpu" ]] && cpu="256"
[[ -z "$ecstaskrolename" ]] && ecstaskrolename="kj_ecsTaskExecutionRole"
[[ -z "$servicename" ]] && servicename="kloudjet_app_service"
[[ -z "$launch_type" ]] && launch_type="FARGATE"
[[ -z "$desired_count" ]] && desired_count="3"
[[ -z "$container_port" ]] && container_port="8080"
[[ -z "$assign_public_ip" ]] && assign_public_ip="true"
[[ -z "$app_service_sg_ingress_from_port" ]] && app_service_sg_ingress_from_port="0"
[[ -z "$app_service_sg_ingress_to_port" ]] && app_service_sg_ingress_to_port="0"
[[ -z "$app_service_sg_ingress_protocol" ]] && app_service_sg_ingress_protocol="-1"
[[ -z "$app_service_sg_egress_from_port" ]] && app_service_sg_egress_from_port="0"
[[ -z "$app_service_sg_egress_to_port" ]] && app_service_sg_egress_to_port="0"
[[ -z "$app_service_sg_egress_protocol" ]] && app_service_sg_egress_protocol="-1"
[[ -z "$app_service_sg_egress_cidr_blocks" ]] && app_service_sg_egress_cidr_blocks="[\"0.0.0.0/0\"]"
[[ -z "$regiona" ]] && regiona="us-east-1a"
[[ -z "$regionb" ]] && regionb="us-east-1b"
[[ -z "$regionc" ]] && regionc="us-east-1c"
[[ -z "$lbname" ]] && lbname="nodejs-lb-fargate"
[[ -z "$load_balancer_type" ]] && load_balancer_type="application"
[[ -z "$lb_sg_ingress_from_port" ]] && lb_sg_ingress_from_port="80"
[[ -z "$lb_sg_ingress_to_port" ]] && lb_sg_ingress_to_port="80"
[[ -z "$lb_sg_ingress_protocol" ]] && lb_sg_ingress_protocol="tcp"
[[ -z "$lb_sg_ingress_cidr_blocks" ]] && lb_sg_ingress_cidr_blocks="[\"0.0.0.0/0\"]"
[[ -z "$lb_sg_ingress_ipv6_cidr_blocks" ]] && lb_sg_ingress_ipv6_cidr_blocks="[\"::/0\"]"
[[ -z "$lb_sg_egress_from_port" ]] && lb_sg_egress_from_port="0"
[[ -z "$lb_sg_egress_to_port" ]] && lb_sg_egress_to_port="0"
[[ -z "$lb_sg_egress_protocol" ]] && lb_sg_egress_protocol="-1"
[[ -z "$lb_sg_egress_cidr_blocks" ]] && lb_sg_egress_cidr_blocks="[\"0.0.0.0/0\"]"
[[ -z "$lb_sg_egress_ipv6_cidr_blocks" ]] && lb_sg_egress_ipv6_cidr_blocks="[\"::/0\"]"
[[ -z "$tgname" ]] && tgname="kloudjettargetgroup"
[[ -z "$lb_tg_port" ]] && lb_tg_port="80"
[[ -z "$lb_tg_protocol" ]] && lb_tg_protocol="HTTP"
[[ -z "$target_type" ]] && target_type="ip"
[[ -z "$matcher" ]] && matcher="200,301,302"
[[ -z "$path" ]] && path="/"
[[ -z "$healthy_threshold" ]] && healthy_threshold="3"
[[ -z "$unhealthy_threshold" ]] && unhealthy_threshold="10"
[[ -z "$timeout" ]] && timeout="3"
[[ -z "$interval" ]] && interval="10"
[[ -z "$lb_tg_health_protocol" ]] && lb_tg_health_protocol="HTTP"
[[ -z "$lb_listener_port" ]] && lb_listener_port="80"
[[ -z "$lb_listener_protocol" ]] && lb_listener_protocol="HTTP"
[[ -z "$lb_listener_type" ]] && lb_listener_type="forward"
[[ -z "$max_capacity" ]] && max_capacity="4"
[[ -z "$min_capacity" ]] && min_capacity="1"
[[ -z "$scalable_dimension" ]] && scalable_dimension="ecs:service:DesiredCount"
[[ -z "$service_namespace" ]] && service_namespace="ecs"
[[ -z "$aspolicyname" ]] && aspolicyname="app_as_memory_autoscaling"
[[ -z "$policy_type_memory" ]] && policy_type_memory="TargetTrackingScaling"
[[ -z "$predefined_metric_type_memory" ]] && predefined_metric_type_memory="ECSServiceAverageMemoryUtilization"
[[ -z "$target_value_memory" ]] && target_value_memory="80"
[[ -z "$appautoscaling_policy_name" ]] && appautoscaling_policy_name="app_as_cpu_autoscaling"
[[ -z "$policy_type_cpu" ]] && policy_type_cpu="TargetTrackingScaling"
[[ -z "$predefined_metric_type_cpu" ]] && predefined_metric_type_cpu="ECSServiceAverageCPUUtilization"
[[ -z "$target_value_cpu" ]] && target_value_cpu="60"
[[ -z "$origin_protocol_policy" ]] && origin_protocol_policy="http-only"
[[ -z "$http_port" ]] && http_port="80"
[[ -z "$https_port" ]] && https_port="443"
[[ -z "$origin_ssl_protocols" ]] && origin_ssl_protocols="[\"TLSv1.2\"]"
[[ -z "$enabled" ]] && enabled="true"
[[ -z "$allowed_methods" ]] && allowed_methods="[\"DELETE\", \"GET\", \"HEAD\", \"OPTIONS\", \"PATCH\", \"POST\", \"PUT\"]"
[[ -z "$cached_methods" ]] && cached_methods="[\"GET\", \"HEAD\", \"OPTIONS\"]"
[[ -z "$cache_policy_id" ]] && cache_policy_id="658327ea-f89d-4fab-a63d-7e88639e58f6"
[[ -z "$origin_request_policy_id" ]] && origin_request_policy_id="59781a5b-3903-41f3-afcb-af62929ccde1"
[[ -z "$response_headers_policy_id" ]] && response_headers_policy_id="60669652-455b-4ae9-85a4-c4c02393f86c"   
[[ -z "$viewer_protocol_policy" ]] && viewer_protocol_policy="allow-all"
[[ -z "$restriction_type" ]] && restriction_type="none"
[[ -z "$cloudfront_default_certificate" ]] && cloudfront_default_certificate="true"

echo "Following values will be used..."

echo region : $region
echo reponame : $reponame
echo image_tag_mutability : $image_tag_mutability
echo force_delete : $force_delete
echo clustername : $clustername
echo ecs_task_family : $ecs_task_family
echo requires_compatibilities : $requires_compatibilities
echo network_mode : $network_mode
echo memory : $memory
echo cpu : $cpu
echo ecstaskrolename : $ecstaskrolename
echo servicename : $servicename
echo launch_type : $launch_type
echo desired_count : $desired_count
echo container_port : $container_port
echo assign_public_ip : $assign_public_ip
echo app_service_sg_ingress_from_port : $app_service_sg_ingress_from_port
echo app_service_sg_ingress_to_port : $app_service_sg_ingress_to_port
echo app_service_sg_ingress_protocol : $app_service_sg_ingress_protocol
echo app_service_sg_egress_from_port : $app_service_sg_egress_from_port
echo app_service_sg_egress_to_port : $app_service_sg_egress_to_port
echo app_service_sg_egress_protocol : $app_service_sg_egress_protocol
echo app_service_sg_egress_cidr_blocks : $app_service_sg_egress_cidr_blocks
echo regiona : $regiona
echo regionb : $regionb
echo regionc : $regionc
echo lbname : $lbname
echo load_balancer_type : $load_balancer_type
echo lb_sg_ingress_from_port : $lb_sg_ingress_from_port
echo lb_sg_ingress_to_port : $lb_sg_ingress_to_port
echo lb_sg_ingress_protocol : $lb_sg_ingress_protocol
echo lb_sg_ingress_cidr_blocks : $lb_sg_ingress_cidr_blocks
echo lb_sg_ingress_ipv6_cidr_blocks : $lb_sg_ingress_ipv6_cidr_blocks
echo lb_sg_egress_from_port : $lb_sg_egress_from_port
echo lb_sg_egress_to_port : $lb_sg_egress_to_port
echo lb_sg_egress_protocol : $lb_sg_egress_protocol
echo lb_sg_egress_cidr_blocks : $lb_sg_egress_cidr_blocks
echo lb_sg_egress_ipv6_cidr_blocks : $lb_sg_egress_ipv6_cidr_blocks
echo tgname : $tgname
echo lb_tg_port : $lb_tg_port
echo lb_tg_protocol : $lb_tg_protocol
echo target_type : $target_type
echo matcher : $matcher
echo path : $path
echo healthy_threshold : $healthy_threshold
echo unhealthy_threshold : $unhealthy_threshold
echo timeout : $timeout
echo interval : $interval
echo lb_tg_health_protocol : $lb_tg_health_protocol
echo lb_listener_port : $lb_listener_port
echo lb_listener_protocol : $lb_listener_protocol
echo lb_listener_type : $lb_listener_type
echo max_capacity : $max_capacity
echo min_capacity : $min_capacity
echo scalable_dimension : $scalable_dimension
echo service_namespace : $service_namespace
echo aspolicyname : $aspolicyname
echo policy_type_memory : $policy_type_memory
echo predefined_metric_type_memory : $predefined_metric_type_memory
echo target_value_memory : $target_value_memory
echo appautoscaling_policy_name : $appautoscaling_policy_name
echo policy_type_cpu : $policy_type_cpu
echo predefined_metric_type_cpu : $predefined_metric_type_cpu
echo target_value_cpu : $target_value_cpu
echo origin_protocol_policy : $origin_protocol_policy
echo http_port : $http_port
echo https_port : $https_port
echo origin_ssl_protocols : $origin_ssl_protocols
echo enabled : $enabled
echo allowed_methods : $allowed_methods
echo cached_methods : $cached_methods
echo cache_policy_id : $cache_policy_id
echo origin_request_policy_id : $origin_request_policy_id
echo response_headers_policy_id : $response_headers_policy_id
echo viewer_protocol_policy : $viewer_protocol_policy
echo restriction_type : $restriction_type
echo cloudfront_default_certificate : $cloudfront_default_certificate
echo createdBy : $createdBy
echo project : $project
echo projectComponent : $projectComponent
echo env : $env

cd infra
echo "Configuring AWS..."
aws configure set aws_access_key_id $access_key && aws configure set aws_secret_access_key $secret_key && aws configure set default.region $region

echo "Initializing..."
terraform init -reconfigure

echo "Destruction of resources will take few minutes..."
terraform destroy -var region=$region -var reponame=$reponame -var image_tag_mutability=$image_tag_mutability -var force_delete=$force_delete -var clustername=$clustername -var ecs_task_family=$ecs_task_family -var requires_compatibilities=$requires_compatibilities -var network_mode=$network_mode -var memory=$memory -var cpu=$cpu -var ecstaskrolename=$ecstaskrolename -var servicename=$servicename -var launch_type=$launch_type -var desired_count=$desired_count -var container_port=$container_port -var assign_public_ip=$assign_public_ip -var app_service_sg_ingress_from_port=$app_service_sg_ingress_from_port -var app_service_sg_ingress_to_port=$app_service_sg_ingress_to_port -var app_service_sg_ingress_protocol=$app_service_sg_ingress_protocol -var app_service_sg_egress_from_port=$app_service_sg_egress_from_port -var app_service_sg_egress_to_port=$app_service_sg_egress_to_port -var app_service_sg_egress_protocol=$app_service_sg_egress_protocol -var app_service_sg_egress_cidr_blocks=$app_service_sg_egress_cidr_blocks -var regiona=$regiona -var regionb=$regionb -var regionc=$regionc -var lbname=$lbname -var load_balancer_type=$load_balancer_type -var lb_sg_ingress_from_port=$lb_sg_ingress_from_port -var lb_sg_ingress_to_port=$lb_sg_ingress_to_port -var lb_sg_ingress_protocol=$lb_sg_ingress_protocol -var lb_sg_ingress_cidr_blocks=$lb_sg_ingress_cidr_blocks -var lb_sg_ingress_ipv6_cidr_blocks=$lb_sg_ingress_ipv6_cidr_blocks -var lb_sg_egress_from_port=$lb_sg_egress_from_port -var lb_sg_egress_to_port=$lb_sg_egress_to_port -var lb_sg_egress_protocol=$lb_sg_egress_protocol -var lb_sg_egress_cidr_blocks=$lb_sg_egress_cidr_blocks -var lb_sg_egress_ipv6_cidr_blocks=$lb_sg_egress_ipv6_cidr_blocks -var tgname=$tgname -var lb_tg_port=$lb_tg_port -var lb_tg_protocol=$lb_tg_protocol -var target_type=$target_type -var matcher=$matcher -var path=$path -var healthy_threshold=$healthy_threshold -var unhealthy_threshold=$unhealthy_threshold -var timeout=$timeout -var interval=$interval -var lb_tg_health_protocol=$lb_tg_health_protocol -var lb_listener_port=$lb_listener_port -var lb_listener_protocol=$lb_listener_protocol -var lb_listener_type=$lb_listener_type -var max_capacity=$max_capacity -var min_capacity=$min_capacity -var scalable_dimension=$scalable_dimension -var service_namespace=$service_namespace -var aspolicyname=$aspolicyname -var policy_type_memory=$policy_type_memory -var predefined_metric_type_memory=$predefined_metric_type_memory -var target_value_memory=$target_value_memory -var appautoscaling_policy_name=$appautoscaling_policy_name -var policy_type_cpu=$policy_type_cpu -var predefined_metric_type_cpu=$predefined_metric_type_cpu -var target_value_cpu=$target_value_cpu -var origin_protocol_policy=$origin_protocol_policy -var http_port=$http_port -var https_port=$https_port -var origin_ssl_protocols=$origin_ssl_protocols -var enabled=$enabled -var allowed_methods=$allowed_methods -var cached_methods=$cached_methods -var cache_policy_id=$cache_policy_id -var origin_request_policy_id=$origin_request_policy_id -var response_headers_policy_id=$response_headers_policy_id -var viewer_protocol_policy=$viewer_protocol_policy -var restriction_type=$restriction_type -var cloudfront_default_certificate=$cloudfront_default_certificate -var createdBy=$createdBy -var project=$project -var projectComponent=$projectComponent -var env=$env -auto-approve

echo "Destroyed all resources..."