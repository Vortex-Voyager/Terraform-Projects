#!/bin/bash
# Update the system
echo "Updating the system..."
yum update -y

# Install Java (OpenJDK 11)
echo "Installing Java..."
yum install -y java-11-openjdk

# Define variables
TOMCAT_VERSION="10.1.9"
TOMCAT_URL="https://dlcdn.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz"
INSTALL_DIR="/opt/tomcat"

# Download and install Apache Tomcat
echo "Downloading and installing Apache Tomcat..."
wget $TOMCAT_URL -P /tmp
tar -xvzf /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt
mv /opt/apache-tomcat-${TOMCAT_VERSION} $INSTALL_DIR

# Set permissions for Tomcat
echo "Configuring permissions..."
chmod +x $INSTALL_DIR/bin/*.sh

# Start Tomcat
echo "Starting Apache Tomcat..."
$INSTALL_DIR/bin/startup.sh

# Confirm Tomcat is running
echo "Tomcat setup completed. You can access it at http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8080"
