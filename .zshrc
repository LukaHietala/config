# chsh -s $(which zsh) - Make zsh the default shell for your user
# Basic prompt
PROMPT='%n@%m %~ %# '

# Unlimited history at cache
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.cache/zsh/history"

# Extra history improvements
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)	

# Movements

# Go reverse on lists
bindkey -M menuselect '^[[Z' reverse-menu-complete 
# Move word by word
bindkey "^[[1;5C" forward-word  
bindkey "^[[1;5D" backward-word

# Navigation
setopt AUTO_CD
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Other aliases
alias clip='xclip -selection clipboard'

# Dmenu history
function dmenu_history() {
  local selected
  selected=$(fc -l -500 | tac |dmenu -l 20 -p "History:" | sed 's/^[[:space:]]*[0-9]\+[[:space:]]*//')
  if [[ -n "$selected" ]]; then
    print -s "$selected"
    eval "$selected"
  fi
}

alias dmhist=dmenu_history

# Exports
export GPG_TTY=$(tty)
export SUDO_ASKPASS="/usr/bin/dmenu-askpass"

