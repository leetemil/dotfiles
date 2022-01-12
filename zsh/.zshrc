autoload -U compinit && compinit
setopt globdots

source ~/.zplug/init.zsh

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY

zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/command-not-found",   from:oh-my-zsh
zplug "plugins/colored-man-pages",   from:oh-my-zsh
zplug "plugins/colorize",   from:oh-my-zsh
zplug "plugins/history",   from:oh-my-zsh
zplug "lib/",   from:oh-my-zsh

zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zsh-users/zsh-completions", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search"


# if you need kube completion
# source <(kubectl completion zsh)
# source <(minikube completion zsh)

ZSH_COLORIZE_TOOL=chroma
ZSH_COLORIZE_STYLE="colorful"

zplug load

eval "$(starship init zsh)"
