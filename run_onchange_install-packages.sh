#!/bin/bash

# Update keys
# Update repos/packages
sudo apt-get update

# Install packages
deps=()
pkgs=(zsh git wget tmux fzf fd-find, bat)

sudo apt-get -y --ignore-missing install "${deps[@]}" 
sudo apt-get -y --ignore-missing install "${pkgs[@]}" 

# Install packages from tar

## Lazy docker
wget https://github.com/jesseduffield/lazydocker/releases/download/v0.20.0/lazydocker_0.20.0_Linux_x86_64.tar.gz -P /tmp && \
tar -xvzf /tmp/lazydocker_0.20.0_Linux_x86_64.tar.gz -C /tmp && \
sudo cp /tmp/lazydocker /usr/local/bin

# install cargo cargo install tealdeer
# tdlr --seed-config
