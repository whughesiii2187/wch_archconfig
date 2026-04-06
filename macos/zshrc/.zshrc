# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Which plugins would you like to load?
plugins=(
  git
  kubectl
  helm
  docker
  docker-compose
  podman
)


# User configuration
zstyle ':completion:*' use-cache no
ZSH_THEME="miloshadzic"
source $ZSH/oh-my-zsh.sh

alias vi="nvim"
alias v="nvim"
alias vim="nvim"
alias getmyip="dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com"
alias python="python3"
alias devpod="~/scripts/dc.sh"
alias genpass="~/scripts/randomgen.py"
alias gg="lazygit"
alias ff='nvim "$(fzf)"'
alias acr="az login && az acr login -n r1k8sacrdev"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/bill.hughes/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

if [[ "$TERM" == "xterm-kitty" || "$TERM" == "xterm-ghostty" ]]; then
  export TERM=xterm-256color
fi
