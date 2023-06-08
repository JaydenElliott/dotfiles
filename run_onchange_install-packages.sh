#!/bin/bash

pkgs=(zsh git wget tmux)
sudo apt-get -y --ignore-missing install "${pkgs[@]}" 
