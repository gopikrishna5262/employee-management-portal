#!/bin/bash
set -e

ARTIFACT_BUCKET="dev-empportal-artifacts-360131674413"
WAR_NAME="backend.war"
TOMCAT_HOME="/opt/tomcat"

# Your secret name in Secrets Manager
SECRET_NAME="dev/empportal/db"

echo "======================================"
echo "Fetching database secret..."
echo "======================================"

SECRET=$(aws secretsmanager get-secret-value \
  --secret-id ${SECRET_NAME} \
  --query SecretString \
  --output text)

HOST=$(echo "$SECRET" | jq -r .host)
PORT=$(echo "$SECRET" | jq -r .port)
DB=$(echo "$SECRET" | jq -r .dbname)
USER=$(echo "$SECRET" | jq -r .username)
PASS=$(echo "$SECRET" | jq -r .password)

echo "Generating Tomcat environment..."

cat > ${TOMCAT_HOME}/bin/setenv.sh <<EOF
#!/bin/bash
export SPRING_DATASOURCE_URL=jdbc:mysql://$HOST:$PORT/$DB
export SPRING_DATASOURCE_USERNAME=$USER
export SPRING_DATASOURCE_PASSWORD=$PASS
EOF

chmod +x ${TOMCAT_HOME}/bin/setenv.sh
chown tomcat:tomcat ${TOMCAT_HOME}/bin/setenv.sh

echo "======================================"
echo "Downloading latest artifact..."
echo "======================================"

aws s3 cp s3://${ARTIFACT_BUCKET}/${WAR_NAME} /tmp/${WAR_NAME}

echo "Stopping Tomcat..."
systemctl stop tomcat

echo "Removing old deployment..."
rm -rf ${TOMCAT_HOME}/webapps/backend
rm -f ${TOMCAT_HOME}/webapps/backend.war

echo "Deploying new WAR..."
cp /tmp/${WAR_NAME} ${TOMCAT_HOME}/webapps/

echo "Starting Tomcat..."
systemctl start tomcat

echo "Waiting for application..."
sleep 30

echo "Checking application health..."

curl -f http://localhost:8080/backend/actuator/health

echo
echo "Deployment completed successfully."