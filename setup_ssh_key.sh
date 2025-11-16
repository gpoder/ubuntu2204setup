#!/usr/bin/env bash
set -e

echo "---------------------------------------------"
echo " Ubuntu 24.04 SSH Setup Script"
echo " Ensuring SSH is installed, configured, and a"
echo " new SSH keypair is created for the user:"
echo "   $USER"
echo "---------------------------------------------"

# Install OpenSSH server
echo "📦 Installing SSH server..."
sudo apt update -y
sudo apt install -y openssh-server

# Enable + start SSH service
echo "🔧 Enabling SSH service..."
sudo systemctl enable ssh
sudo systemctl start ssh

# Ensure ~/.ssh exists
echo "📁 Creating ~/.ssh directory if needed..."
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Generate SSH key (if not already present)
KEY_PATH="$HOME/.ssh/id_rsa"

if [[ -f "$KEY_PATH" ]]; then
    echo "🔑 SSH key already exists at $KEY_PATH"
else
    echo "🔑 Generating a new SSH key..."
    ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N ""
fi

# Add public key to authorized_keys
echo "📥 Adding SSH public key to authorized_keys..."
cat "$KEY_PATH.pub" >> ~/.ssh/authorized_keys

# Fix permissions
chmod 600 ~/.ssh/authorized_keys

# Restart SSH for safety
echo "🔄 Restarting SSH service..."
sudo systemctl restart ssh

echo "---------------------------------------------"
echo "✅ SSH setup complete!"
echo "You can now SSH into this machine using:"
echo "  ssh $USER@<IP_ADDRESS>"
echo
echo "Your public key is:"
echo "---------------------------------------------"
cat "$KEY_PATH.pub"
echo "---------------------------------------------"
