#!/bin/bash

KIND_VERSION=0.22.0
HELM_VERSION=3.14.0
# In case kubectl is missing, we will download the latest stable version
ISTIOD_VERSION=1.19.4


KIND_BINARY=$(which kind)
KUBECTL_BINARY=$(which kubectl)
HELM_BINARY=$(which helm)
ISTIOCTL_BINARY=$(which istioctl)


CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"


# --------------------------------------
download_k8s_tools() {
    echo -e "\n\t===== Downloading tools if needed ...\n"

    # For Intel Macs
    [[ $(uname -m) == x86_64 && $(uname -o) = Darwin ]] && KIND_PLATFORM="amd64" && KIND_OS="darwin"
    # For M1 / ARM Macs
    [[ $(uname -m) = arm64   && $(uname -o) = Darwin ]] && KIND_PLATFORM="arm64" && KIND_OS="darwin"
    # For Linux AMD64 / x86_64
    [[ $(uname -m) = x86_64  && $(uname -o) = GNU/Linux ]]  && KIND_PLATFORM="amd64" && KIND_OS="linux"
    # For Linux ARM64
    [[ $(uname -m) = aarch64 && $(uname -o) = GNU/Linux ]]  && KIND_PLATFORM="arm64" && KIND_OS="linux"

    export KIND_PLATFORM=${KIND_PLATFORM}
    export KIND_OS=${KIND_OS}

    # download KIND cli
    if [[ -z "${KIND_BINARY}" ]]; then
        KIND_BINARY=${CURRENT_DIR}/kind
    fi

    if [[ -z "${KIND_BINARY}" || ! -f "${KIND_BINARY}" ]]; then
        KIND_BINARY=${CURRENT_DIR}/kind
        echo -e "\n\t--- Downloading KIND cli ...\n"
        curl -Lo ${KIND_BINARY} https://kind.sigs.k8s.io/dl/v${KIND_VERSION}/kind-${KIND_OS}-${KIND_PLATFORM}
        chmod +x ${KIND_BINARY}
    else
        echo -e "\n\t--- Found ${KIND_BINARY}. No need to download it.\n"
    fi

    # download kubectl
    if [[ -z "${KUBECTL_BINARY}" ]]; then
        KUBECTL_BINARY=${CURRENT_DIR}/kubectl
    fi

    if [[ -z "${KUBECTL_BINARY}" || ! -f "${KUBECTL_BINARY}" ]]; then
        KUBECTL_BINARY=${CURRENT_DIR}/kubectl
        echo -e "\n\t--- Downloading KUBECTL cli ...\n"
        curl -Lo ${KUBECTL_BINARY} "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${KIND_OS}/${KIND_PLATFORM}/kubectl"
        chmod +x ${KUBECTL_BINARY}
    else
        echo -e "\n\t--- Found ${KUBECTL_BINARY}. No need to download it.\n"
    fi

    # download helm
    if [[ -z "${HELM_BINARY}" ]]; then
        HELM_BINARY=${CURRENT_DIR}/helm
    fi

    if [[ -z "${HELM_BINARY}" || ! -f "${HELM_BINARY}" ]]; then
        HELM_BINARY=${CURRENT_DIR}/helm
        echo -e "\n\t--- Downloading HELM cli ...\n"
        curl -Lo ${CURRENT_DIR}/helm.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-${KIND_OS}-${KIND_PLATFORM}.tar.gz
        pushd ${CURRENT_DIR}
        tar -zxvf helm.tar.gz
        popd
        mv ${CURRENT_DIR}/${KIND_OS}-${KIND_PLATFORM}/helm ${CURRENT_DIR}/
        chmod +x ${HELM_BINARY}
        rm -rf ${CURRENT_DIR}/${KIND_OS}-${KIND_PLATFORM}  ${CURRENT_DIR}/helm.tar.gz
    else
        echo -e "\n\t--- Found ${HELM_BINARY}. No need to download it.\n"
    fi

    # download istioctl
    if [[ -z "${ISTIOCTL_BINARY}" ]]; then
        ISTIOCTL_BINARY=${CURRENT_DIR}/istioctl
    fi

    if [[ -z "${ISTIOCTL_BINARY}" || ! -f "${ISTIOCTL_BINARY}" ]]; then
        ISTIOCTL_BINARY=${CURRENT_DIR}/istioctl
        echo -e "\n\t--- Downloading ISTIO cli ...\n"

        pushd ${CURRENT_DIR}
        curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIOD_VERSION} sh -
        mv ./istio-${ISTIOD_VERSION}/bin/istioctl ./
        popd

        chmod +x ${ISTIOCTL_BINARY}
        rm -r ${CURRENT_DIR}/istio-${ISTIOD_VERSION}
    else
        echo -e "\n\t--- Found ${ISTIOCTL_BINARY}. No need to download it.\n"
    fi
}


download_k8s_tools