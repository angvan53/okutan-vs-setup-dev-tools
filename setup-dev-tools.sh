#!/bin/bash

set -e

echo "📦 WSL ortamı için DevOps araçları kuruluyor..."

# APT kontrolü
if ! command -v apt &> /dev/null; then
  echo "❌ apt bulunamadı. Bu betik yalnızca WSL + Ubuntu ortamı içindir."
  exit 1
fi

# Güncelleme ve temel araçlar
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y
sudo apt install -y curl wget gnupg lsb-release software-properties-common apt-transport-https ca-certificates git unzip jq

#######################################
# GitHub CLI
#######################################
echo "🔧 GitHub CLI kuruluyor..."
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
  sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
  https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install gh -y

#######################################
# Terraform
#######################################
echo "🔧 Terraform kuruluyor..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform -y

#######################################
# Docker CLI (Docker Desktop ile entegre çalışır)
#######################################
echo "🐳 Docker Desktop ile uyumlu CLI kuruluyor..."
sudo apt install -y docker.io docker-compose
sudo usermod -aG docker $USER

#######################################
# kubectl
#######################################
echo "🔧 kubectl kuruluyor..."
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

#######################################
# Helm
#######################################
echo "🔧 Helm kuruluyor..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

#######################################
# Ansible
#######################################
echo "🔧 Ansible kuruluyor..."
sudo apt install -y ansible

#######################################
# yq (manual kurulum, snap yoksa)
#######################################
echo "🔧 yq kuruluyor..."
YQ_VERSION=v4.40.5
wget https://github.com/mikefarah/yq/releases/download/$YQ_VERSION/yq_linux_amd64 -O yq
chmod +x yq
sudo mv yq /usr/local/bin

#######################################
# k9s
#######################################
echo "🔧 k9s kuruluyor..."
curl -Lo k9s.tgz https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz
tar -xzf k9s.tgz k9s
sudo mv k9s /usr/local/bin
rm k9s.tgz

#######################################
# kubectx & kubens installation
#######################################
echo "🔧 kubectx ve kubens kuruluyor..."
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx || echo "🔁 Zaten var."
sudo ln -sf /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -sf /opt/kubectx/kubens /usr/local/bin/kubens

#######################################
# terraform-docs
#######################################
echo "🔧 terraform-docs kuruluyor..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep tag_name | cut -d '"' -f 4)
wget https://github.com/terraform-docs/terraform-docs/releases/download/$LATEST_VERSION/terraform-docs-$LATEST_VERSION-$(uname -s | tr '[:upper:]' '[:lower:]')-amd64.tar.gz -O terraform-docs.tar.gz
tar -xzf terraform-docs.tar.gz terraform-docs
sudo mv terraform-docs /usr/local/bin/
rm terraform-docs.tar.gz

#######################################
# Versiyon Kontrolü
#######################################
echo ""
echo "📋 Kurulu araçlar ve sürümleri:"

echo -n "GitHub CLI:       "; gh --version | head -n 1
echo -n "Terraform:        "; terraform version | head -n 1
echo -n "Docker:           "; docker --version
echo -n "Docker Compose:   "; docker-compose --version
echo -n "kubectl:          "; kubectl version --client --short
echo -n "Helm:             "; helm version --short
echo -n "Ansible:          "; ansible --version | head -n 1
echo -n "jq:               "; jq --version
echo -n "yq:               "; yq --version
echo -n "k9s:              "; k9s version
echo -n "kubectx:          "; kubectx --help | head -n 1
echo -n "kubens:           "; kubens --help | head -n 1
echo -n "terraform-docs:   "; terraform-docs --version

echo ""
echo "✅ WSL ortamı için DevOps araçları başarıyla kuruldu!"