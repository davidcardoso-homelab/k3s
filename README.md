# k3s

Projeto destinado à criação, configuração e gerenciamento de um cluster Kubernetes (k3s) de forma automatizada e reprodutível.

## Estrutura do Projeto

```
setup/
  config.yaml           # Configuração customizada do k3s
  setup-k3s.sh          # Script de instalação e configuração do k3s
  uninstall-k3s.sh      # Script para desinstalar o k3s
  argocd/
    install.sh          # (Reservado para instalação do ArgoCD)
README.md
```

## Pré-requisitos

- Linux
- Permissão de sudo
- Git instalado

## Instalação do k3s

1. Clone este repositório:
    ```sh
    git clone https://github.com/davidcardoso-homelab/k3s.git
    cd k3s/setup
    ```

2. (Opcional) Edite o arquivo [`config.yaml`](setup/config.yaml) conforme sua necessidade. Este arquivo define parâmetros do cluster k3s, como CIDRs, modo do kubeconfig, etc.

3. Execute o script de instalação:
    ```sh
    chmod +x setup-k3s.sh
    ./setup-k3s.sh
    ```

    O script irá:
    - Copiar automaticamente o [`config.yaml`](setup/config.yaml) para `/etc/rancher/k3s/config.yaml` (caso exista).
    - Instalar o k3s apenas se ainda não estiver instalado.
    - Aguardar o cluster e todos os pods ficarem prontos.
    - Copiar o kubeconfig para `~/.kube/config` e ajustar permissões.
    - Remover qualquer binário antigo do kubectl instalado via k3s.

    > **Obs:** O script é idempotente e pode ser executado várias vezes sem causar problemas.

## Desinstalação do k3s

Para remover o k3s do sistema, execute:

```sh
chmod +x uninstall-k3s.sh
./uninstall-k3s.sh
```

## Versionando o ambiente

Sempre que alterar scripts ou arquivos de configuração, faça commit das mudanças:

```sh
git add .
git commit -m "Descreva sua alteração"
git push
```

Para reproduzir o ambiente em outro servidor, basta clonar este repositório e executar o script novamente.

---

## kubectl

O `kubectl` é a ferramenta oficial de linha de comando para gerenciar clusters Kubernetes.

### Documentação oficial

- [Documentação do kubectl](https://kubernetes.io/docs/reference/kubectl/)

### Como instalar o kubectl (Linux)

Execute os comandos abaixo para instalar a versão oficial do kubectl:

```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
kubectl version --client
```

---


## Instalação do ArgoCD

O ArgoCD pode ser instalado facilmente após o cluster k3s estar pronto, utilizando o script já disponível no projeto.

### Passos para instalar o ArgoCD

1. Certifique-se de que o cluster k3s está rodando e o `kubectl` está configurado corretamente.
2. Execute o script de instalação do ArgoCD:
    ```sh
    cd setup/argocd
    chmod +x install.sh
    ./install.sh
    ```
    O script irá:
    - Criar o namespace `argocd`.
    - Aplicar o manifesto oficial de instalação do ArgoCD.

3. Aguarde alguns minutos até que todos os pods do ArgoCD estejam prontos:
    ```sh
    kubectl get pods -n argocd
    ```

4. (Opcional) Para acessar o painel web do ArgoCD fora do cluster, altere o tipo do serviço para NodePort:
    ```sh
    kubectl -n argocd patch svc argocd-server -p '{"spec": {"type": "NodePort"}}'
    kubectl -n argocd get svc argocd-server
    ```
    O comando acima exibirá a porta externa para acesso ao painel.

5. Para obter a senha inicial do usuário `admin`:
    ```sh
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
    ```

Para mais detalhes, consulte o arquivo [`install.sh`](setup/argocd/install.sh).

---

Para mais informações sobre o k3s, acesse: [https://docs.k3s.io/](https://docs.k3s.io/)