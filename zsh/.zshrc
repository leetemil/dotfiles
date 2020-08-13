source ~/repositories/dotfiles/zsh/antigen.zsh

# Load the oh-my-zsh library
antigen use oh-my-zsh

plugins=(
    # bundles from oh-my-zsh
    git
    pip
    command-not-found
    kubectl
    colored-man-pages
    cargo
    # bundles from repositories
    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-completions
)

for plugin ($plugins); do
    antigen bundle $plugin
done

# apply antigen
antigen apply
