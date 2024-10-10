# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Exports
export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8
export GOPATH=$HOME/go
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin:$HOME/.local/bin"

# Editor configuration
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Oh My Zsh configuration
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git
  docker
  kubectl
  python
  pip
  zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

# Custom functions
function _tmux_sessions() {
    sessions=("${(@f)$(tmux list-sessions -F '#{session_name}')}")
    _wanted sessions expl 'tmux sessions' compadd -a sessions
}
compdef _tmux_sessions tkill

function fuzzycd() {
  local file=$(find . -type f | fzf --query="$1" +m)
  if [ -n "$file" ]; then
    cd "$(dirname "$file")" || return
  fi
}

# Aliases
alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
alias update='sudo dnf update'

# File listing aliases (using exa if available)
if command -v exa &> /dev/null; then
  alias l='exa -lh'
  alias ls='exa -1'
  alias la='exa -lha --sort=name --group-directories-first'
  alias ld='exa -lhD'
  alias lt='exa --tree'
else
  alias l='ls -lh'
  alias ls='ls -1'
  alias la='ls -lha'
  alias ld='ls -ld'
  alias lt='tree -h --du ./'
fi

alias ll='ls -la'

# Other helpful aliases
alias tls='tmux ls'
alias n='nvim'
alias tkill='tmux kill-session -t'
alias fcd=fuzzycd

# Load Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Additional PATH and library configurations
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"

# zoxide configuration
eval "$(zoxide init --cmd cd zsh)"
