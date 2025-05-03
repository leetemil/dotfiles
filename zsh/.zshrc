autoload -U compinit && compinit
setopt globdots

source ~/.zplug/init.zsh

# aws completion, jfrog completion
source /usr/local/bin/aws_zsh_completer.sh
source ~/.jfrog/jfrog_zsh_completion

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# zstyle ':autocomplete:*' default-context history-incremental-search-backward

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# The meaning of these options can be found in man page of `zshoptions`.
setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY  # record command start time

setopt MENU_COMPLETE

bindkey '^[[Z' reverse-menu-complete

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '^H' backward-kill-word

bindkey '^R' history-incremental-search-backward
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/command-not-found",   from:oh-my-zsh
zplug "plugins/colored-man-pages",   from:oh-my-zsh
zplug "plugins/colorize",   from:oh-my-zsh
zplug "plugins/history",   from:oh-my-zsh
zplug "lib/",   from:oh-my-zsh
zplug "junegunn/fzf"
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zsh-users/zsh-completions", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search"

zplug load


# random version tool 'asdf' found on internet; so far it's pretty good
. /opt/asdf-vm/asdf.sh

# if you need kube completion
source <(kubectl completion zsh)
source <(minikube completion zsh)
source <(k9s completion zsh)

ZSH_COLORIZE_TOOL=chroma
ZSH_COLORIZE_STYLE="colorful"

# neovim
alias vim=nvim
alias vi=nvim

# ugly csv to json one-liner
alias csvtojson="python -c 'import csv, json, sys; print(json.dumps([dict(r) for r in csv.DictReader(sys.stdin)]))' | jq"

# vscode wayland-style; will open current directory. works as of 2022-10-20
# alias c="code --enable-features=UseOzonePlatform --ozone-platform=wayland ."


export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"
export EDITOR=nvim
export VISUAL=nvim


export PATH="/home/empe/.local/bin:$PATH"
eval "$(starship init zsh)"

[ -f "/home/empe/.ghcup/env" ] && source "/home/empe/.ghcup/env" # ghcup-env

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /home/empe/.asdf/installs/terraform/1.1.6/bin/terraform terraform
