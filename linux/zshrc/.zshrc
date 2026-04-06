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
ZSH_THEME="fishy"
source $ZSH/oh-my-zsh.sh

alias vi="nvim"
alias v="nvim"
alias gg="lazygit"
alias ff="fzf"
alias getmyip="dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com"
alias python="python3"
alias devpod="~/scripts/dc"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
export SSH_AUTH_SOCK=/home/bill/.bitwarden-ssh-agent.sock
