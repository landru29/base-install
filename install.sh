#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    mkdir -p ${HOME}/bin
    mkdir -p ${HOME}/projects/go/bin


    #Install rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    #Install kind
    curl -Lo ${HOME}/bin/kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-$(uname)-amd64
    chmod +x ${HOME}/bin/kind

    #Install k9s
    curl -Lo /tmp/k9s.tar.gz https://github.com/derailed/k9s/releases/download/v0.29.1/k9s_Linux_amd64.tar.gz
    tar -xzf /tmp/k9s.tar.gz -C ${HOME}/bin/
    chmod +x ${HOME}/bin/k9s

    #Install ohMyZsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    echo "export PATH=\$PATH:/opt/go/bin:$HOME/.cargo/bin:$HOME/bin:$HOME/projects/go/bin" >> ~/.profile
    echo "export GOPATH=$HOME/projects/go/bin" >> ~/.profile

    echo "source .profile" >> ~/.zshrc
    exit 0
fi

apt update
apt install -y gpg curl
apt full-upgrade -y

# Prepare VS Code repository
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

# Install dependencies
apt update
apt install -y zsh \
    git \
    curl \
    wget \
    unzip \
    build-essential \
    cmake \
    python3-dev \
    python3-pip \
    nodejs \
    npm \
    arandr \
    cmake \
    bzip2 \
    code \
    curl \
    gimp \
    vlc \
    gmt \
    jq \
    vim \
    qgis \
    sqlite3 \
    terminator \
    net-tools \
    gpg \
    pipx

# Install GO
GO_VERSION="1.26.4"
curl -Lo /tmp/go.tar.gz https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
mkdir -p /opt/go_${GO_VERSION}
tar -xzf /tmp/go.tar.gz -C /opt/go_${GO_VERSION} --strip-components=1
rm /tmp/go.tar.gz
rm -f /opt/go
sudo ln -s /opt/go_${GO_VERSION} /opt/go
echo "export PATH=\$PATH:/opt/go/bin" >> ~/.profile

# Install helm
snap install helm --classic


