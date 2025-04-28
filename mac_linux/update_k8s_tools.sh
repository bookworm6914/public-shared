#!/bin/bash

#
# Download the latest version of the Kubernetes tools
#

TYPE_PLATFORM=""
TYPE_OS=""

KIND_BINARY=
KUBECTL_BINARY=
HELM_BINARY=
ISTIOCTL_BINARY=
MINIKUBE_BINARY=
K9S_BINARY=

# Refer to https://en.wikipedia.org/wiki/ANSI_escape_code for coloBRED escape codes
BRED='\e[0;91m'
BGREEN='\e[0;92m'
BYELLOW='\e[0;93m'
NC='\033[0m'           # No Color


CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
echo -e "\n\t===== Downloading the latest bits of K8s tools if needed ...\n"


# --------------------------------------
check_settings() {
    # For Intel Macs
    [[ $(uname -m) == x86_64 && $(uname -o) = Darwin ]] && TYPE_PLATFORM="amd64" && TYPE_OS="darwin"
    # For M1 / ARM Macs
    [[ $(uname -m) = arm64   && $(uname -o) = Darwin ]] && TYPE_PLATFORM="arm64" && TYPE_OS="darwin"
    # For Linux AMD64 / x86_64
    [[ $(uname -m) = x86_64  && $(uname -o) = GNU/Linux ]]  && TYPE_PLATFORM="amd64" && TYPE_OS="linux"
    # For Linux ARM64
    [[ $(uname -m) = aarch64 && $(uname -o) = GNU/Linux ]]  && TYPE_PLATFORM="arm64" && TYPE_OS="linux"

    if ! jq --help &> /dev/null ; then
        echo -e "${BRED}***** ERROR ***** jq is not installed${NC}\n"
        exit 101
    fi
}


# --------------------------------------
download_kind_cli() {
    if [[ -z "${KIND_BINARY}" ]]; then
        KIND_BINARY=${CURRENT_DIR}/kind
    fi

    if [[ -z "${KIND_BINARY}" || ! -f "${KIND_BINARY}" ]]; then

        # curl -sL https://api.github.com/repos/kubernetes-sigs/kind/releases | jq -r '.[0].assets[] | .browser_download_url'
        latest_version=$(curl -sL https://api.github.com/repos/kubernetes-sigs/kind/releases | jq -r '.[0].name')
        echo -e "\n\t--- Downloading KIND cli ${latest_version} ...\n"

        curl -Lo ${KIND_BINARY} https://github.com/kubernetes-sigs/kind/releases/download/${latest_version}/kind-${TYPE_OS}-${TYPE_PLATFORM}
        chmod +x ${KIND_BINARY}

    else
        echo -e "\n\t--- Found ${KIND_BINARY}. No need to download it.\n"
    fi
}


# --------------------------------------
download_minikube() {
    if [[ -z "${MINIKUBE_BINARY}" ]]; then
        MINIKUBE_BINARY=${CURRENT_DIR}/minikube
    fi

    if [[ -z "${MINIKUBE_BINARY}" || ! -f "${MINIKUBE_BINARY}" ]]; then

        echo -e "\n\t--- Downloading latest version of minikube ...\n"

        curl -Lo ${MINIKUBE_BINARY} https://storage.googleapis.com/minikube/releases/latest/minikube-${TYPE_OS}-${TYPE_PLATFORM}
        chmod +x ${MINIKUBE_BINARY}

    else
        echo -e "\n\t--- Found ${MINIKUBE_BINARY}. No need to download it.\n"
    fi
}


# --------------------------------------
download_kubectl() {
    if [[ -z "${KUBECTL_BINARY}" ]]; then
        KUBECTL_BINARY=${CURRENT_DIR}/kubectl
    fi

    if [[ -z "${KUBECTL_BINARY}" || ! -f "${KUBECTL_BINARY}" ]]; then
        latest_version=$(curl -L -s https://dl.k8s.io/release/stable.txt)
        echo -e "\n\t--- Downloading KUBECTL cli ${latest_version} ...\n"
        curl -Lo ${KUBECTL_BINARY} "https://dl.k8s.io/release/${latest_version}/bin/${TYPE_OS}/${TYPE_PLATFORM}/kubectl"
        chmod +x ${KUBECTL_BINARY}

    else
        echo -e "\n\t--- Found ${KUBECTL_BINARY}. No need to download it.\n"
    fi
}


# --------------------------------------
download_helm() {
    if [[ -z "${HELM_BINARY}" ]]; then
        HELM_BINARY=${CURRENT_DIR}/helm
    fi

    if [[ -z "${HELM_BINARY}" || ! -f "${HELM_BINARY}" ]]; then
        latest_version=$(curl -sL https://api.github.com/repos/helm/helm/releases | jq -r '.[0].name' | tr -d "Helm ")
        echo -e "\n\t--- Downloading HELM cli ${latest_version} ...\n"

        curl -Lo ${CURRENT_DIR}/helm.tar.gz https://get.helm.sh/helm-${latest_version}-${TYPE_OS}-${TYPE_PLATFORM}.tar.gz
        tar -zxvf ${CURRENT_DIR}/helm.tar.gz -C ${CURRENT_DIR}/tmp
        mv ${CURRENT_DIR}/tmp/${TYPE_OS}-${TYPE_PLATFORM}/helm ${CURRENT_DIR}/
        chmod +x ${HELM_BINARY}
        rm -rf ${CURRENT_DIR}/tmp/${TYPE_OS}-${TYPE_PLATFORM}  ${CURRENT_DIR}/helm.tar.gz

    else
        echo -e "\n\t--- Found ${HELM_BINARY}. No need to download it.\n"
    fi
}


# --------------------------------------
download_istioctl() {
    if [[ -z "${ISTIOCTL_BINARY}" ]]; then
        ISTIOCTL_BINARY=${CURRENT_DIR}/istioctl
    fi

    if [[ -z "${ISTIOCTL_BINARY}" || ! -f "${ISTIOCTL_BINARY}" ]]; then
        latest_version=$(curl -sL https://api.github.com/repos/istio/istio/releases/latest | jq -r '.name' | tr -d "Istio ")
        echo -e "\n\t--- Downloading ISTIO cli ${latest_version} ...\n"

        curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${latest_version} sh -
        mv ./istio-${latest_version}/bin/istioctl ${CURRENT_DIR}

        chmod +x ${ISTIOCTL_BINARY}
        rm -r ./istio-${latest_version}
    else
        echo -e "\n\t--- Found ${latest_version}. No need to download it.\n"
    fi
}


# --------------------------------------
download_k9s() {
    if [[ -z "${K9S_BINARY}" ]]; then
        K9S_BINARY=${CURRENT_DIR}/k9s
    fi

    if [[ -z "${K9S_BINARY}" || ! -f "${K9S_BINARY}" ]]; then
        latest_version=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | jq '.name' | tr -d '"')
        echo -e "\n\t--- Downloading k9s ${latest_version} ...\n"

        curl -LO https://github.com/derailed/k9s/releases/download/${latest_version}/k9s_${TYPE_OS^}_${TYPE_PLATFORM}.tar.gz
        tar -zxvf ${CURRENT_DIR}/k9s_${TYPE_OS^}_${TYPE_PLATFORM}.tar.gz -C ${CURRENT_DIR}/tmp
        mv ${CURRENT_DIR}/tmp/k9s ${CURRENT_DIR}
        rm *.tar.gz    ${CURRENT_DIR}/tmp/*

    else
        echo -e "\n\t--- Found ${latest_version}. No need to download it.\n"
    fi
}


mkdir ${CURRENT_DIR}/tmp
# to comment out multiple lines, use : '  ...  '
check_settings
download_kind_cli
download_minikube
download_kubectl
download_helm
download_istioctl
download_k9s

rm -r -f ${CURRENT_DIR}/tmp
