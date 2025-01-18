#!/bin/bash

# Update and install Nginx
sudo apt update && sudo apt install -y nginx unzip

# Variables for storage account and blob
STORAGE_ACCOUNT_NAME="jdsa1"
STORAGE_ACCOUNT_KEY=""  # Replace this with the key from Terraform
CONTAINER_NAME="sa1-c1"
BLOB_NAME="my-web-app.zip"
DESTINATION="/var/www/html"

# Install Azure CLI to download the blob (if not pre-installed)
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Use storage account key to download the blob
az storage blob download \
    --account-name "$STORAGE_ACCOUNT_NAME" \
    --container-name "$CONTAINER_NAME" \
    --name "$BLOB_NAME" \
    --file "/tmp/$BLOB_NAME" \
    --account-key "$STORAGE_ACCOUNT_KEY"

# Extract the ZIP file and move the contents to Nginx web root
sudo unzip -o "/tmp/$BLOB_NAME" -d "$DESTINATION"

# Restart Nginx to serve the new content
sudo systemctl restart nginx

