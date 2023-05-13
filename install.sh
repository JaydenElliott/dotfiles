#!/bin/bash

#################################################################
#                             ZSH                               #
#################################################################
if command -v zsh &> /dev/null && command -v git &> /dev/null && command -v wget &> /dev/null; then
    echo -e "Zsh and Git are already installed\n"
else
    echo -e "Installing zsh, git and wget\n"
    if sudo apt install -y zsh git wget; then
        echo -e "zsh wget and git Installed\n"
    else
        echo -e "Please install the following packages first, then try again: zsh git wget \n" && exit
    fi
fi

#################################################################
#                            TMUX                               #
#################################################################
if command -v tmux &> /dev/null; then
    echo -e "Tmux is already installed\n"
else
    if sudo apt install -y tmux; then
        echo -e "\n\nInstalling tmux\n\n"
        echo -e "Tmux Installed\n"
    fi
fi
cp -f .tmux.conf ~/


#################################################################
#                             RUST                              #
#################################################################
if command -v rustup &> /dev/null && command -v cargo &> /dev/null; then
    echo -e "cargo is already installed"
else
    echo -e "\n\nInstalling Rust\n\n"
    if sudo curl https://sh.rustup.rs -sSf | sh -s -- -y && source "$HOME/.cargo/env"; then
        echo -e "Rust Installed\n"
    else
        echo -e "Failed to install rust, install manually and restart install \n" && exit
    fi
fi


#################################################################
#                             NVIM                              #
#################################################################
if command -v bob &> /dev/null; then
    echo -e "nvim-bob is already installed"
else
    echo -e "\n\nInstalling nvim version manager Bob\n\n"
    cargo install bob-nvim
fi

if command -v nvim &> /dev/null; then
    echo -e "Nvim already installed\n"
else
    echo -e "\n\nInstalling nvim\n\n"
    bob use stable
fi

echo -e "\n\Copying init.vim to ~/.config/nvim and installing plugins\n\n"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
mkdir -p ~/.config/nvim
cp -f init.vim ~/.config/nvim/init.vim
nvim --headless +PlugInstall +qall


#################################################################
#                PREPARE ZSH PLUGIN INSTALLATION                #
#################################################################
cp -f zsh/.zshrc ~/
cp -f zsh/.jayden-zshrc ~/.config/zsh/
echo -e "Zsh configs installed at '~/.config/zsh'\n"


#################################################################
#                           OH-MY-ZSH                           #
#################################################################
echo -e "\n\nInstalling oh-my-zsh\n\n"
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


#################################################################
#                      ZSH-AUTOSUGGESTIONS                      #
#################################################################
if [ -d ~/.config/zsh/oh-my-zsh/plugins/zsh-autosuggestions ]; then
    cd ~/.config/zsh/oh-my-zsh/plugins/zsh-autosuggestions && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/oh-my-zsh/plugins/zsh-autosuggestions
fi


#################################################################
#                         ZSH-COMPLETIONS                       #
#################################################################
if [ -d ~/.config/zsh/oh-my-zsh/custom/plugins/zsh-completions ]; then
    cd ~/.config/zsh/oh-my-zsh/custom/plugins/zsh-completions && git pull
else
    git clone --depth=1 https://github.com/zsh-users/zsh-completions ~/.config/zsh/oh-my-zsh/custom/plugins/zsh-completions
fi


#################################################################
#                              FZF                              #
#################################################################
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



#################################################################
#         VERIFY ZSH INSTALL AND UPDATE DEFAULT SHELL           #
#################################################################
echo -e "\n\nUpdating default shell\nn"
if chsh -s $(which zsh) && /bin/zsh -i; then
    echo -e "Installation Successful, exit terminal and enter a new session"
else
    echo -e "Something is wrong"
fi

cd ~/Documents/repos/dotfiles
exit

