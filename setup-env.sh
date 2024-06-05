#!/usr/bin/env bash

## Cluster
cat <<EOF > /tmp/kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: argocd-testing
networking:
  disableDefaultCNI: true
  kubeProxyMode: none
nodes:
  - role: control-plane
  - role: worker
  - role: worker
EOF

## CNI
cilium install
cilium status --wait
cilium hubble enable --ui --relay

## Cloud-Provider KIND
curl -sSL -o cp-kind.tar.gz https://github.com/kubernetes-sigs/cloud-provider-kind/releases/download/v0.2.0/cloud-provider-kind_0.2.0_linux_amd64.tar.gz
tar -xzf cp-kind.tar.gz 
rm cp-kind.tar.gz
mkdir ./bin
mv cloud-provider-kind ./bin

## Argo CD
kubectl create ns --force argocd
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml -n argocd
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

## Proxy
sudo apt install mitmproxy -y

## Finishing
echo "KIND CP: ./bin/cloud-provider-kind"
echo "Hubble: cilium hubble ui"
echo "Argo CD: kubectl port-forward -n argocd svc/argocd-server 8080:8080"
echo "Mitmweb: mitmweb --listen-port 9090"