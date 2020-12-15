
#!/bin/bash

echo "[TASK 1] Install ingesss nginx controller"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress ingress-nginx/ingress-nginx

echo "[TASK 2] Configure MetallB"
su - vagrant -c "kubectl create -f /vagrant/metallb/configmap.yaml"
