#!/bin/bash
set -euo pipefail
ENV=$1

# Single instance per environment — find it by its Name tag instead of an ASG
ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=${ENV}-app" "Name=instance-state-name,Values=running" \
  --query "Reservations[0].Instances[0].InstanceId" --output text)

WAR_FILE=$(ls application/backend/target/*.war)

echo "Deploying to $ID"
aws ssm send-command \
  --instance-ids "$ID" \
  --document-name "AWS-RunShellScript" \
  --comment "Deploy ${ENV}" \
  --parameters commands="[
    'sudo systemctl stop tomcat',
    'sudo cp /opt/tomcat/webapps/ROOT.war /opt/tomcat/webapps/ROOT.war.bak || true',
    'aws s3 cp s3://empportal-artifacts-<yourid>/${ENV}/$(basename $WAR_FILE) /opt/tomcat/webapps/ROOT.war',
    'sudo systemctl start tomcat',
    'sleep 15',
    'curl -f http://localhost:8080/actuator/health || (sudo cp /opt/tomcat/webapps/ROOT.war.bak /opt/tomcat/webapps/ROOT.war && sudo systemctl restart tomcat && exit 1)'
  ]" \
  --output text