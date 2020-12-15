
#!/bin/bash

# Initialize Kubernetes
echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=192.168.10.10 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

# Copy Kube admin config
echo "[TASK 2] Copy kube admin config to Vagrant user .kube directory"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "[TASK 3] Install Helm"
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash >/dev/null 2>&1
sudo ln -s  /usr/local/bin/helm /usr/bin/helm >/dev/null 2>&1

# Deploy flannel network
echo "[TASK 4] Deploy flannel network"
curl https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml -o kube-flannel.yml >/dev/null 2>&1
sed 's/vxlan/host-gw/' -i kube-flannel.yml  >/dev/null 2>&1
kubectl apply -f kube-flannel.yml >/dev/null 2>&1

echo "[TASK 5] Install MetalB"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml >/dev/null 2>&1
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml >/dev/null 2>&1
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" >/dev/null 2>&1

echo "[TASK 6] Install k9s, mc, nano"
curl -L https://github.com/derailed/k9s/releases/download/v0.23.10/k9s_Linux_x86_64.tar.gz -o k9s_Linux_x86_64.tar.gz >/dev/null 2>&1
tar -zxvf  k9s_Linux_x86_64.tar.gz k9s >/dev/null 2>&1
sudo cp k9s /usr/bin >/dev/null 2>&1 
sudo yum install mc nano -y

# Generate Cluster join command
echo "[TASK 7] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh
