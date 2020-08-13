autoload -U compinit && compinit

# Dynamically load plugins every time
# source <(antibody init)
# antibody bundle < ~/dotfiles/zsh/zsh_plugins.txt

# statically load plugins (faster, allegedly)
# if you update your plugins, run load_plugins.sh
source ~/dotfiles/zsh/zsh_plugins.sh

source <(kubectl completion zsh)
source <(minikube completion zsh)

source ~/dotfiles/zsh/prompt.sh

ZSH_COLORIZE_TOOL=chroma
ZSH_COLORIZE_STYLE="colorful"


# aliases
alias python=python3.8
alias pip=pip3.8
alias vim="nvim -p"
alias v="nvim -p"

# make ls after cd
chpwd() ls