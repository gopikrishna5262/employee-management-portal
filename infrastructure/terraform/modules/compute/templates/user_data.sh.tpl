#!/bin/bash
set -e
dnf install -y java-17-amazon-corretto amazon-cloudwatch-agent

# Install Tomcat 10
useradd -m -d /opt/tomcat tomcat || true
cd /opt
curl -O https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.24/bin/apache-tomcat-10.1.24.tar.gz
tar xzf apache-tomcat-10.1.24.tar.gz
ln -s apache-tomcat-10.1.24 tomcat
chown -R tomcat:tomcat /opt/tomcat* /opt/apache-tomcat-10.1.24

cat >/etc/systemd/system/tomcat.service <<'EOF'
[Unit]
Description=Tomcat
After=network.target
[Service]
Type=forking
User=tomcat
Environment=JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto
Environment=CATALINA_HOME=/opt/tomcat
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now tomcat

aws secretsmanager get-secret-value --secret-id "${db_secret_arn}" \
  --query SecretString --output text > /opt/tomcat/db-secret.json
chown tomcat:tomcat /opt/tomcat/db-secret.json
chmod 600 /opt/tomcat/db-secret.json

echo "ENVIRONMENT=${environment}" >> /etc/environment