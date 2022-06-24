#            _
#    _______| |__  _ __ ___
#   |_  / __| '_ \| '__/ __|
#  _ / /\__ \ | | | | | (__
# (_)___|___/_| |_|_|  \___|
#
# The individual per-interactive-shell startup file

# == GENERAL ==================================================================

setopt AUTO_CD    # Allows you to cd into directory merely by typing the directory name
setopt AUTO_MENU  # Automatically  use  menu completion after the second consecutive request for completion, for example by pressing the tab key repeatedly.

# Set up the prompt

# autoload -Uz promptinit && promptinit
# prompt adam2

# Enable colors and change prompt
autoload -U colors && colors


# PS1 is your normal "waiting for a command" prompt

PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# PS2 is the continuation prompt that you saw after typing an incomplete command
PS2="> "

# Set file mode creation mask. Default value is 0022
umask 0022

# Keep 10000000 lines of history within the shell and save it to ~/.zsh_history:

HISTFILE=~/.config/zsh/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000

setopt APPEND_HISTORY          # Allow multiple terminal sessions to all append to one zsh command history
setopt BANG_HIST               # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY        # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY      # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY           # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST  # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS        # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS    # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS       # Do not display a line previously found.
setopt HIST_IGNORE_SPACE       # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS       # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY             # Don't execute immediately upon history expansion.
setopt HIST_BEEP               # Beep when accessing nonexistent history.

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Use vi keybindings
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char


### Use modern completion system
#autoload -Uz compinit && compinit
#compinit
#
#zstyle ':completion:*' auto-description 'specify: %d'
#zstyle ':completion:*' completer _expand _complete _correct _approximate
#zstyle ':completion:*' format 'Completing %d'
#zstyle ':completion:*' group-name ''
#zstyle ':completion:*' menu select=2
#eval "$(dircolors -b)"
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#zstyle ':completion:*' list-colors ''
#zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
#zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
#zstyle ':completion:*' menu select=long
#zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
#zstyle ':completion:*' use-compctl false
#zstyle ':completion:*' verbose true
#
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
#zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


# == FUNCTIONS ================================================================

# Shorter version of a common command that it used herein.
function _checkexec() {
	command -v "$1" > /dev/null
}

# Enter directory and list contents.
function cd() {
	if [ -n "$1" ]; then
		builtin cd "$@" && ls -pvA --color=auto --group-directories-first
	else
		builtin cd ~ && ls -pvA --color=auto --group-directories-first
	fi
}

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Extract files
function extract {
  echo Extracting $1 ...
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xjf $1  ;;
          *.tar.gz)    tar xzf $1  ;;
          *.bz2)       bunzip2 $1  ;;
          *.rar)       unrar x $1    ;;
          *.gz)        gunzip $1   ;;
          *.tar)       tar xf $1   ;;
          *.tbz2)      tar xjf $1  ;;
          *.tgz)       tar xzf $1  ;;
          *.zip)       unzip $1   ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1  ;;
          *)        echo "'$1' cannot be extracted via extract()" ;;
      esac
  else
      echo "'$1' is not a valid file"
  fi
}

# == VARIABLE =================================================================

# Default terminal
export TERMINAL="xterm"

# Default editor
if _checkexec gvim; then
	# export VISUAL="gvim"
	export VISUAL="vim"
	export EDITOR="vim"
else
	export VISUAL="vim"
	export EDITOR=$VISUAL
fi

# Default browser
export BROWSER="iceweasel"

# Default reader
export READER="zathura"

# Default file manager
export FILE="vifm"

# Man pages locale priority
export MANOPT="-L ru"

# Default pager. Show location as a percentage in pager
export PAGER="less -s -M +Gg"

# Default man pager
export MANPAGER="$PAGER"

# Specify the path to the askpass helper program.
# Check SUDO(8) for more information
export SUDO_ASKPASS="/usr/bin/ssh-askpass"

export FONTCONFIG_PATH="/etc/fonts"

#export TERM="screen-256color"
export TERM="xterm-256color"

# Colourise less/man
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"; a="${a%_}"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"; a="${a%_}"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"; a="${a%_}"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"; a="${a%_}"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"; a="${a%_}"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"; a="${a%_}"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"; a="${a%_}"

# less syntax highlighting
# source-highlight package required
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"

# Include scripts in the PATH
if [ -d "$HOME/.local/bin/scripts" ]; then
    # export PATH=$PATH:"$HOME"/.local/bin/scripts
    export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
fi

# NNN file manager

export NNN_OPTS="d"
export NNN_OPENER="nano"
export NNN_BMS="~:$HOME;d:~/Documents;p:~/Documents/Projects"

# Adding /snap/bin to default $PATH makes running snaps
export PATH=$PATH:"/snap/bin"

# Adding cabal to default $PATH
export PATH=$PATH:"$HOME/.cabal/bin"

# QT
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_SCALE_FACTOR=1.00

# == ALIASES ==================================================================

# Make ls a bit easier to read and enable color
# support of ls and also add handy aliases
alias ls='ls -pv --color=auto --group-directories-first'
alias lsa='ls -pvA --color=auto --group-directories-first'
alias lsl='ls -lhpv --color=auto --group-directories-first'
alias lsla='ls -lhpvA --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'

# Git
if _checkexec git; then
    alias gs='git status'
    alias gl='git log --all --graph --decorate --oneline'
    alias ga='git add'
    alias gb='git branch'
    alias gc='git commit'
    alias gd='git diff'
    alias go='git checkout'
fi

# APT
if _checkexec apt; then
    alias install='sudo apt install'
    alias purge='sudo apt purge'
    alias show='sudo apt show -a'
fi

# Safer default for cp, mv, rm.  These will print a verbose output of
# the operations.  If an existing file is affected, they will ask for
# confirmation.  This can make things a bit more cumbersome, but is a
# generally safer option.
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'

alias cpr='rsync --progress -auv'

# Quick navigation
alias DE='~/Desktop'
alias DC='~/Documents'
alias DO='~/Downloads'
alias MU='~/Music'
alias PI='~/Pictures'
alias PB='~/Public'
alias TE='~/Templates'
alias VI='~/Videos'
alias TM='/tmp'
alias RD='/mnt/ramdisk'

# Others
if _checkexec vim; then
    alias v='vim'
    alias vi='vim'
fi
alias o='xdg-open '
alias weather='clear && curl wttr.in'
alias myip='curl http://ipecho.net/plain; echo'
alias apt='sudo apt'
alias figlet='figlet -d ${HOME}/.local/share/figlet'
alias pb='p-builder.sh'
alias pf='cd ${HOME}/Documents/Projects/'
alias kon='sudo service kerio-kvc start'
alias koff='sudo service kerio-kvc stop'
alias won='sudo wg-quick up wg0'
alias woff='sudo wg-quick down wg0'


# == FZF ======================================================================

# A command-line fuzzy finder
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] &&
    source /usr/share/doc/fzf/examples/key-bindings.zsh

# fzf search include hidden files, preview and ignore .git (Required fdfind package)
if _checkexec fdfind; then
    export FZF_DEFAULT_COMMAND='fdfind --hidden --exclude ".git" .'

    export FZF_CTRL_T_OPTS='--multi'
    export FZF_CTRL_T_COMMAND='fdfind --hidden --exclude ".git" .'

    export FZF_ALT_C_OPTS='--preview="ls --group-directories-first {+}"'
    export FZF_ALT_C_COMMAND='fdfind --type d --hidden --exclude ".git" .'
fi

# == PLUGINS ==================================================================

# -- Powerlevel10k ------------------------------------------------------------

# Load powerlevel10k
[ -f ~/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme ] &&
    source ~/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# -----------------------------------------------------------------------------

# Load nnn confguration script 'cd on quit'
[ -f ~/.config/zsh/plugins/nnn/misc/quitcd/quitcd.bash_zsh ] &&
    source ~/.config/zsh/plugins/nnn/misc/quitcd/quitcd.bash_zsh

bindkey -s '^o' '^un\n'  # Bind nnn on C-o

# Load zsh autosuggestions
[ -f ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] &&
    source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Load syntax highlighting; should be last.
[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] &&
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# == OTHERS ===================================================================

# Shows Linux System Information with Distribution Logo.
# Configuration file .config/neofetch/config.conf
#if _checkexec neofetch; then
#    neofetch
#fi

