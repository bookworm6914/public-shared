#!/bin/bash

TYPE_PLATFORM=""
TYPE_OS=""

KIND_BINARY=
KUBECTL_BINARY=
HELM_BINARY=
ISTIOCTL_BINARY=


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
}


# --------------------------------------
download_kind_cli() {
    if [[ -z "${KIND_BINARY}" ]]; then
        KIND_BINARY=${CURRENT_DIR}/kind
    fi

    if [[ -z "${KIND_BINARY}" || ! -f "${KIND_BINARY}" ]]; then
        echo -e "\n\t--- Downloading KIND cli ...\n"

        # curl -sL https://api.github.com/repos/kubernetes-sigs/kind/releases | jq -r '.[0].assets[] | .browser_download_url'
        latest_version=$(curl -sL https://api.github.com/repos/kubernetes-sigs/kind/releases | jq -r '.[0].name')
        curl -Lo ${KIND_BINARY} https://github.com/kubernetes-sigs/kind/releases/download/${latest_version}/kind-${TYPE_OS}-${TYPE_PLATFORM}
        chmod +x ${KIND_BINARY}

    else
        echo -e "\n\t--- Found ${KIND_BINARY}. No need to download it.\n"
    fi
}


# --------------------------------------
download_kubectl() {
    if [[ -z "${KUBECTL_BINARY}" ]]; then
        KUBECTL_BINARY=${CURRENT_DIR}/kubectl
    fi

    if [[ -z "${KUBECTL_BINARY}" || ! -f "${KUBECTL_BINARY}" ]]; then
        echo -e "\n\t--- Downloading KUBECTL cli ...\n"
        curl -Lo ${KUBECTL_BINARY} "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${TYPE_OS}/${TYPE_PLATFORM}/kubectl"
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
        echo -e "\n\t--- Downloading HELM cli ...\n"

        latest_version=$(curl -sL https://api.github.com/repos/helm/helm/releases | jq -r '.[0].name' | tr -d "Helm ")
        curl -Lo ${CURRENT_DIR}/helm.tar.gz https://get.helm.sh/helm-v${latest_version}-${TYPE_OS}-${TYPE_PLATFORM}.tar.gz

        tar -zxvf helm.tar.gz
        mv ${CURRENT_DIR}/${TYPE_OS}-${TYPE_PLATFORM}/helm ${CURRENT_DIR}/
        chmod +x ${HELM_BINARY}
        rm -rf ${CURRENT_DIR}/${TYPE_OS}-${TYPE_PLATFORM}  ${CURRENT_DIR}/helm.tar.gz

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
        echo -e "\n\t--- Downloading ISTIO cli ...\n"

        latest_version=$(curl -sL https://api.github.com/repos/istio/istio/releases/latest | jq -r '.name' | tr -d "Istio ")

        curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${latest_version} sh -
        mv ./istio-${latest_version}/bin/istioctl ./

        chmod +x ${ISTIOCTL_BINARY}
        rm -r ${CURRENT_DIR}/istio-${latest_version}
    else
        echo -e "\n\t--- Found ${latest_version}. No need to download it.\n"
    fi
}


check_settings
download_kind_cli
download_kubectl
download_helm
download_istioctl