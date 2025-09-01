# k3s
Projeto destinado à criação e configuração do Kubernetes (k3s)

## Como usar este repositório

Este repositório contém scripts para instalar e configurar um cluster k3s de forma automatizada e reprodutível.

### Pré-requisitos
- Linux
- Permissão de sudo
- Git instalado


### Passos para instalar o k3s
1. Clone este repositório:
	```sh
	git clone https://github.com/davidcardoso-homelab/k3s.git
	cd k3s/setup
	```
2. (Opcional) Edite o arquivo `config.yaml` conforme sua necessidade. Este arquivo define parâmetros do cluster k3s, como nome do nó, CIDRs, IPs, etc.
3. Execute o script de instalação:
	```sh
	chmod +x setup-k3s.sh
	./setup-k3s.sh
	```

O script irá copiar automaticamente o `config.yaml` para o local correto (`/etc/rancher/k3s/config.yaml`) antes de instalar o k3s. Se o arquivo não existir, a configuração padrão do k3s será usada.

O script é idempotente: pode ser executado várias vezes sem causar problemas.

### Versionando o ambiente
- Sempre que alterar scripts ou arquivos de configuração, faça commit das mudanças:
  ```sh
  git add .
  git commit -m "Descreva sua alteração"
  git push
  ```
- Para reproduzir o ambiente em outro servidor, basta clonar este repositório e executar o script novamente.

---

## kubectl

O `kubectl` é a ferramenta oficial de linha de comando para gerenciar clusters Kubernetes.

### Documentação oficial
- Documentação do kubectl: https://kubernetes.io/docs/reference/kubectl/

### Como instalar o kubectl (Linux)
Execute os comandos abaixo para instalar a versão oficial do kubectl:

```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
kubectl version --client
```

---
Para mais informações sobre o k3s, acesse: https://docs.k3s.io/
