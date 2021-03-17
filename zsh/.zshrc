autoload -U compinit && compinit

setopt globdots

# Dynamically load plugins every time
# source <(antibody init)
# antibody bundle < $HOME/dotfiles/zsh/zsh_plugins.txt

# statically load plugins (faster, allegedly)
# if you update your plugins, run load_plugins.sh
source $HOME/dotfiles/zsh/zsh_plugins.sh

# if you need kube completion
# source <(kubectl completion zsh)
# source <(minikube completion zsh)

ZSH_COLORIZE_TOOL=chroma
ZSH_COLORIZE_STYLE="colorful"

source $HOME/.profile

# aliases
alias vim="nvim -p"
alias v="nvim -p"
alias cat=bat
alias ls=exa

# make ls after cd
chpwd() exa -a 
eval "$(starship init zsh)"
