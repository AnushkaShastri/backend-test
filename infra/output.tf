# Outputs
locals {
    config_map_aws_auth = <<CONFIGMAPAWSAUTH

apiversion: v1
kind: ConfigMap
metadata:
    name: aws-auth
    namespace: kube-system
data:
    mapRoles:  |
       - rolearn: ${aws_iam_role.k8_cluster-node.arn}
         username:  system:node:{{EC2PrivateDNSName}}
         groups:
             - system:bootstrappers
             - system:nodes
CONFIGMAPAWSAUTH



    kubeconfig = <<KUBECONFIG

apiversion: v1
clusters:
  - cluster:
       server: ${aws_eks_cluster.k8_cluster.endpoint}
       certificate-authority-data: ${aws_eks_cluster.k8_cluster.certificate_authority[0].data}
    name: kubernete
contexts:
- context: 
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: config
preferences: {}
users:
- name: aws
  user:
     exec:
        apiVersion: client.authentication.k8.io/v1beta1
        command: aws-iam-authenticator
        args:
           - "token"
           - "-i"
           - "${var.env}_${var.cluster_name}"
KUBECONFIG

}

output "config_map_aws_auth" {
    value = local.config_map_aws_auth

}

output "kubeconfig" {
    value = local.kubeconfig
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.distribution.domain_name
}