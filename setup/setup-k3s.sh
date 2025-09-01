#!/bin/bash
set -e

# Copia o config.yaml customizado para o local correto antes da instalação
if [ -f "$(dirname "$0")/config.yaml" ]; then
  echo "[INFO] Copiando config.yaml para /etc/rancher/k3s/config.yaml"
  sudo mkdir -p /etc/rancher/k3s
  sudo cp "$(dirname "$0")/config.yaml" /etc/rancher/k3s/config.yaml
else
  echo "[WARN] config.yaml não encontrado no diretório do script. Usando configuração padrão do k3s."
fi

if command -v k3s >/dev/null 2>&1; then
  echo "[INFO] k3s já está instalado. Pulando instalação."
else
  # Script de instalação do k3s
  # https://docs.k3s.io/

  echo "[INFO] Instalando k3s..."
  curl -sfL https://get.k3s.io | sh -
fi

echo "[INFO] Aguardando o cluster ficar online..."
until sudo k3s kubectl get node >/dev/null 2>&1; do
  sleep 1
done

# Aguarda todos os pods ficarem prontos
while true; do
  PENDING=$(sudo k3s kubectl get pods --all-namespaces --no-headers | grep -v 'Running\|Completed' | wc -l)
  if [ "$PENDING" -eq 0 ]; then
    break
  fi
  sleep 2
done

# Configura o kubectl local
mkdir -p "$HOME/.kube"
sudo cp /etc/rancher/k3s/k3s.yaml "$HOME/.kube/config"
sudo chown $(id -u):$(id -g) "$HOME/.kube/config"
echo "[INFO] kubeconfig copiado para $HOME/.kube/config"

sudo rm -rf /usr/local/bin/kubectl
