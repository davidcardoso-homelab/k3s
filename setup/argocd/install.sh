#!/bin/bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl -n argocd patch deployment argocd-server --type='json' -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--insecure"}]'
kubectl apply -f ingress.yaml

#echo "A senha do usuário admin do Argo CD é: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)"

#kubectl -n argocd patch svc argocd-server -p '{"spec": {"type": "NodePort"}}'

#kubectl -n argocd get svc argocd-server

