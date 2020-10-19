# /bin/bash
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
  apt -y install curl git unzip
fi

# AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
mv kubectl /usr/local/bin

# Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Terraform
export TERRAFORM_LATEST_STABLE=$(curl -sL  https://releases.hashicorp.com/terraform| grep href| grep terraform| egrep -v "(alpha|beta)" | head -1| cut -f3 -d '/')
curl -L -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_LATEST_STABLE}/terraform_${TERRAFORM_LATEST_STABLE}_linux_amd64.zip
unzip terraform.zip
mv terraform /usr/local/bin

# Cleanup archives
rm *.zip