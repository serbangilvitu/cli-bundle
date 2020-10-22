#! /bin/bash
set -euo pipefail
pushd /tmp
source /etc/os-release

if [[ "${ID}" == 'debian' || "${ID_LIKE}" == 'debian' ]]; then
  DISTRIBUTION='debian'
fi

if [[ -z ${DISTRIBUTION} ]]; then
  echo 'Unsupported distribution'
  exit 1
fi

if [[ "${DISTRIBUTION}" == 'debian' ]]; then
  apt update
  apt -y install curl gettext-base git unzip vim
fi

# AWS CLI
curl -so "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" 
unzip awscliv2.zip
./aws/install

# kubectl
curl -sLO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin

# Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Terraform
export TERRAFORM_LATEST_STABLE=$(curl -sL  https://releases.hashicorp.com/terraform| grep href| grep terraform| egrep -v "(alpha|beta)" | head -1| cut -f3 -d '/')
curl -sL -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_LATEST_STABLE}/terraform_${TERRAFORM_LATEST_STABLE}_linux_amd64.zip
unzip terraform.zip
mv terraform /usr/local/bin

# Cleanup
rm *.zip