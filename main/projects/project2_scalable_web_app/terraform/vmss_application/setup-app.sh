#!/bin/bash

# Install dependencies
sudo apt update && sudo apt install -y nginx unzip

# Download the ZIP file
wget -O /tmp/site.zip  https://jdsa1.blob.core.windows.net/sa1-c1/my-web-app.zip

# Extract the ZIP file
unzip -o /tmp/site.zip -d /tmp/site_content

# Move extracted files to Nginx's web root
sudo mv /tmp/site_content/* /var/www/html/

# Restart Nginx to apply changes
sudo systemctl restart nginx
