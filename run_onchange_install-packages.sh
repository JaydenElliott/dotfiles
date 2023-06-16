#!/bin/bash

pkgs=(zsh git wget tmux tldr fzf fd-find)
sudo apt-get -y --ignore-missing install "${pkgs[@]}" 
