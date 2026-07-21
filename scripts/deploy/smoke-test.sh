#!/bin/bash
set -e
ENV=$1
IP=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=${ENV}-app" "Name=instance-state-name,Values=running" \
  --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
curl -f "http://${IP}:8080/actuator/health"
curl -f "http://${IP}:8080/employees"