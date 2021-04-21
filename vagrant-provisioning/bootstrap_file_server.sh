#!/bin/bash

# Update hosts file
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
192.168.10.10 kmaster.local kmaster
192.168.10.11 kworker1.local kworker1
192.168.10.12 kworker2.local kworker2
192.168.10.13 file-server.local file-server
EOF

echo "[TASK 2] Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

# Stop and disable firewalld
echo "[TASK 3] Stop and Disable firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld

echo "[TASK 4] Install mc, nano"
sudo yum install mc nano bash-completion -y

echo "[TASK 5] Download and install NFS server"
yum install -y nfs-utils

echo "[TASK 6] Create a kubedata directory"
mkdir -p /srv/nfs/kubedata

echo "[TASK 7] Update the shared folder access"
chmod -R 777 /srv/nfs/kubedata

echo "[TASK 8] Make the kubedata directory available on the network"
cat >>/etc/exports<<EOF
/srv/nfs/kubedata    *(rw,sync,no_subtree_check,no_root_squash)
EOF

echo "[TASK 9] Export the updates"
sudo exportfs -rav

echo "[TASK 10] Enable NFS Server"
sudo systemctl enable nfs-server

echo "[TASK 11] Start NFS Server"
sudo systemctl start nfs-server

# Enable ssh password authentication
echo "[TASK 12] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc