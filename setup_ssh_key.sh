#!/usr/bin/env bash
set -e

SSH_USER="${1:-$USER}"
KEY_PATH="/home/$SSH_USER/.ssh/id_rsa"
AUTHORIZED="/home/$SSH_USER/.ssh/authorized_keys"

echo "=============================="
echo " Installing OpenSSH server"
echo "=============================="
apt update -y
apt install -y openssh-server

echo "=============================="
echo " Ensuring .ssh directory exists"
echo "=============================="
mkdir -p "/home/$SSH_USER/.ssh"
chmod 700 "/home/$SSH_USER/.ssh"
chown $SSH_USER:$SSH_USER "/home/$SSH_USER/.ssh"

echo "=============================="
echo " Generating SSH key (if missing)"
echo "=============================="
if [ ! -f "$KEY_PATH" ]; then
    sudo -u "$SSH_USER" ssh-keygen -t rsa -b 4096 -N "" -f "$KEY_PATH"
fi

echo "=============================="
echo " Installing public key"
echo "=============================="
cat "$KEY_PATH.pub" >> "$AUTHORIZED"
chmod 600 "$AUTHORIZED"
chown $SSH_USER:$SSH_USER "$AUTHORIZED"

echo "=============================="
echo " Enabling SSH service"
echo "=============================="
systemctl enable ssh
systemctl restart ssh

echo "=============================="
echo " OPTIONAL: Disable password auth"
echo "=============================="
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config || true
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config || true
systemctl restart ssh

echo "=============================="
echo " DONE!"
echo " Public key is installed for user: $SSH_USER"
echo " Private key: $KEY_PATH"
echo "=============================="
