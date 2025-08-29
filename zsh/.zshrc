# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export PATH=/Users/aer/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# THEME
#
ZSH_THEME="random"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
# 
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd/mm/yyyy"

# COMPLETION
#
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"
#
# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="%F{blue}...%f"

# AUTO UPDATE
#
# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
#
# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# VCS
#
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# PLUGINS
plugins=(z git docker poetry python vi-mode common-aliases golang node npm tmux)

# PLUGINS CONFIG

# vi-mode
MODE_INDICATOR="%F{blue}N%f"
INSERT_MODE_INDICATOR="%F{blue}I%f"

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

