#!/bin/bash
echo "=== BeforeInstall ==="

# Install Apache if not already installed
if ! command -v httpd &> /dev/null; then
  echo "Installing Apache..."
  sudo yum update -y
  sudo yum install -y httpd
  sudo systemctl enable httpd
fi

# Stop Apache if running
sudo systemctl stop httpd || true
