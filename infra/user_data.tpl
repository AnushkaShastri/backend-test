#!/bin/bash

# Update all packages

sudo yum update -y
sudo yum install -y ecs-init
sudo service docker start
sudo start ecs

#Adding cluster name in ecs config
sudo mkdir -p /etc/ecs
sudo echo  ECS_CLUSTER="${cluster_name}" >> /etc/ecs/ecs.config
cat /etc/ecs/ecs.config | grep "ECS_CLUSTER"

amazon-linux-extras disable docker
amazon-linux-extras install -y ecs
sudo cp /usr/lib/systemd/system/ecs.service /etc/systemd/system/ecs.service
sudo sed -i '/After=cloud-final.service/d' /etc/systemd/system/ecs.service
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl restart ecs
