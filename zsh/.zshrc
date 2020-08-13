autoload -U compinit && compinit

# Dynamically load plugins every time
# source <(antibody init)
# antibody bundle < ~/dotfiles/zsh/zsh_plugins.txt

# statically load plugins (faster, allegedly)
# if you update your plugins, run load_plugins.sh
source ~/dotfiles/zsh/zsh_plugins.sh

source <(kubectl completion zsh)
source <(minikube completion zsh)

# aliases
alias python=python3.8
alias pip=pip3.8
alias vim=nvim
alias v=nvim