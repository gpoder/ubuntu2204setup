#!/usr/bin/env bash
set -e

SHARE="//192.168.1.147/garage-bucket_test"
MOUNTPOINT="/mnt/garage-bucket_test"
CRED_FILE="/etc/samba/garage-bucket_test.cred"
USER="ziggy"
PASS="cookie"

echo "=============================="
echo " Installing SMB client"
echo "=============================="
apt update -y
apt install -y cifs-utils

echo "=============================="
echo " Creating mount directory"
echo "=============================="
mkdir -p "$MOUNTPOINT"

echo "=============================="
echo " Creating credentials file"
echo "=============================="
cat <<EOF > "$CRED_FILE"
username=$USER
password=$PASS
EOF

chmod 600 "$CRED_FILE"

echo "=============================="
echo " Adding entry to /etc/fstab"
echo "=============================="

# Remove old entry if exists
sed -i "\|$MOUNTPOINT|d" /etc/fstab

cat <<EOF >> /etc/fstab
$SHARE   $MOUNTPOINT   cifs   credentials=$CRED_FILE,iocharset=utf8,file_mode=0777,dir_mode=0777,uid=1000,gid=1000,nofail   0   0
EOF

echo "=============================="
echo " Mounting share"
echo "=============================="
mount -a

echo "=============================="
echo " Done!"
echo " Mounted: $SHARE → $MOUNTPOINT"
echo "=============================="
