#!/bin/bash

# ECS config
{
  echo "ECS_CLUSTER=${cluster_name}"
  echo "ECS_ENABLE_CONTAINER_METADATA=true"
} >> /etc/ecs/ecs.config

start ecs

mkdir -p /mnt/efs
mount -t efs -o tls ${efs_file_system}:/ /mnt/efs

echo "Done"