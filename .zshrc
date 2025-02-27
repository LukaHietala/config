export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

zstyle ':omz:update' frequency 13

plugins=(git fnm)

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Paths

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

# GPG
export GPG_TTY=$(tty)

# Fnm
FNM_PATH="${HOME}/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi

# Cargo
export PATH=~/.local/bin:$PATH
. "$HOME/.cargo/env"

# Go
export PATH=$PATH:/usr/local/go/bin

# Aliases

# Brightness
alias br='xrandr --output eDP-1 --brightness'

# Copy/paste on commands
alias cs='xclip -selection clipboard'
alias vs='xclip -o -selection clipboard"'
