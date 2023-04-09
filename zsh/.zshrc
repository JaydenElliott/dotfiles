################# DO NOT MODIFY THIS FILE #######################
############ UPDATE THE ~/.config/zsh/zshrc.sh FILE #############
#################################################################

# Load zsh configurations and plugins
source "$HOME/.config/zsh/.jayden-zshrc"
source $ZSH/oh-my-zsh.sh


# Now source fzf.zsh , otherwise Ctr+r is overwritten by ohmyzsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias k="k -h"       # show human readable file sizes, in kb, mb etc

