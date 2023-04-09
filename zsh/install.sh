#!/bin/bash

# INSTALL ZSH
if command -v zsh &> /dev/null && command -v git &> /dev/null && command -v wget &> /dev/null; then
    echo -e "ZSH and Git are already installed\n"
else
    if sudo apt install -y zsh git wget; then
        echo -e "zsh wget and git Installed\n"
    else
        echo -e "Please install the following packages first, then try again: zsh git wget \n" && exit
    fi
fi

# BACKUP
if cp -n ~/Documents/setup/.jayden-zshrc ~/Documents/setup/jayden-zshrc-backup-$(date +"%Y-%m-%d"); then # backup .zshrc
    echo -e "Backed up the current zshrc to zshrc-backup-date\n"
fi

# Copy this zshrc to root
cp -f .zshrc ~/

# Copy the primary zsh file to config (which is sourced from ~/zshrc.sh)
cp -f .jayden-zshrc ~/.config/zsh/

# PREPARE PLUGIN INSTALLATION
echo -e "The setup will be installed in '~/.config/zsh'\n"

# OH-MY-ZSH
echo -e "Installing oh-my-zsh\n"
if [ -d ~/.config/zsh/oh-my-zsh ]; then
    echo -e "oh-my-zsh is already installed\n"
elif [ -d ~/.oh-my-zsh ]; then
    echo -e "oh-my-zsh in already installed at '~/.oh-my-zsh'. Moving it to '~/.config/zsh/oh-my-zsh'"
    export ZSH="$HOME/.config/zsh/oh-my-zsh"
    mv ~/.oh-my-zsh ~/.config/zsh/oh-my-zsh
    git -C ~/.config/zsh/oh-my-zsh remote set-url origin https://github.com/ohmyzsh/ohmyzsh.git
else
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.config/zsh/oh-my-zsh
fi
if [ -f ~/.zcompdump ]; then
    mv ~/.zcompdump* ~/.cache/zsh/
fi

# ZSH-AUTOSUGGESTIONS
if [ -d ~/.config/zsh/oh-my-zsh/plugins/zsh-autosuggestions ]; then
    cd ~/.config/zsh/oh-my-zsh/plugins/zsh-autosuggestions && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/oh-my-zsh/plugins/zsh-autosuggestions
fi

# ZSH-COMPLETIONS
if [ -d ~/.config/zsh/oh-my-zsh/custom/plugins/zsh-completions ]; then
    cd ~/.config/zsh/oh-my-zsh/custom/plugins/zsh-completions && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-completions ~/.config/zsh/oh-my-zsh/custom/plugins/zsh-completions
fi

# FZF
if [ -d ~/.~/.config/zsh/fzf ]; then
    cd ~/.config/zsh/fzf && git pull
    ~/.config/zsh/fzf/install --all --key-bindings --completion --no-update-rc
else
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.config/zsh/fzf
    ~/.config/zsh/fzf/install --all --key-bindings --completion --no-update-rc
fi

if [ -d ~/.config/zsh/oh-my-zsh/custom/plugins/k ]; then
    cd ~/.config/zsh/oh-my-zsh/custom/plugins/k && git pull
else
    git clone --depth 1 https://github.com/supercrabtree/k ~/.config/zsh/oh-my-zsh/custom/plugins/k
fi

echo -e "\nUpdating default shell - sudo required\n"

if chsh -s $(which zsh) && /bin/zsh -i; then
    echo -e "Installation Successful, exit terminal and enter a new session"
else
    echo -e "Something is wrong"
fi
exit

