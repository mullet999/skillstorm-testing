#!/bin/bash

# Set non-interactive mode for apt
export DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
sudo apt update && sudo apt install -y nginx unzip python3 python3-pip curl

# Install Python libraries
sudo pip3 install pymssql pyodbc azure-identity

# Add Microsoft GPG key and repository (non-interactive)
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo tee /usr/share/keyrings/microsoft.asc
echo "deb [signed-by=/usr/share/keyrings/microsoft.asc] https://packages.microsoft.com/ubuntu/22.04/prod jammy main" | sudo tee /etc/apt/sources.list.d/mssql-release.list

# Update apt and install SQL tools (non-interactive)
sudo apt update
sudo ACCEPT_EULA=Y apt install -y mssql-tools18 unixodbc-dev

# Add mssql-tools18 to PATH
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' | sudo tee -a /etc/profile.d/mssql-tools.sh
source /etc/profile.d/mssql-tools.sh

# odbcinst -q -d

# Download and extract the ZIP file
wget -O /tmp/site.zip https://jdsa1.blob.core.windows.net/sa1-c1/my-web-app.zip
unzip -o /tmp/site.zip -d /tmp/site_content

# Move extracted files to Nginx's web root
sudo mv /tmp/site_content/* /var/www/html/

# Restart Nginx to apply changes
sudo systemctl restart nginx


