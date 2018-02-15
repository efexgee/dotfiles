# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# source /etc/bashrc before interactive check for ssh -t cluster-dev qlogin
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
export HISTIGNORE=$'h:history:clear'

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

#FXG Default prompt
#-----------------------------------
#\[		BEGIN non-printing
#\e]0
#;
#\w		path
#\a		bell
#\]		END non-printing
#\n		newline
#\[\e[32m\]	green color
#\u		username
#@		@ symbol
#\h		hostname (no FQDN)
#		a colon
#\[\e[33m\]	yellow color
#\w		path
#\[\e[0m\]	reset color
#\$		$ symbol (escaped)
# 		a space
#-----------------------------------

#FXG check to see if we're root

if [ "$color_prompt" = yes ]; then
    if [ $(id -u) == 0 ]; then
        #"root" prompt colors username red and replaces $ with a red #
        PS1='\n\T \[\e[91m\]\u\[\e[32m\]@\h:\[\e[33m\]\w\[\e[91m\]#\[\e[0m\] '
        echo "Remember: \"With root power comes root responsibility.\""
    else
        PS1='\n\T \[\e[32m\]\u@\h:\[\e[33m\]\w\[\e[0m\]\$ '
    fi
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    if [ -r $HOME/.dircolors ]; then
        eval "$(dircolors -b)"
        eval "$(dircolors -b $HOME/.dircolors | sed 's/^LS_COLORS=/LS_COLORS=$LS_COLORS:/')"	#FXG: append our colors
    fi

    alias ls='ls -hF --color=auto'	#human-readable, append type indicator character
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#FXG Aliases
if [ -f $HOME/.alias ]; then
    source $HOME/.alias
fi

#FXG Functions
if [ -f $HOME/.function ]; then
    source $HOME/.function
fi

alias h='history'

#FXG: Set color for grep output
#FXG: mc=yellow, should never show (tells you you did something weird)
#FXG: fn=white, make filenames less garish
#FXG: bn=magenta, don't confuse byte num with line num
#FXG: rest are default
export GREP_COLORS='ms=01;31:mc=33:sl=:cx=:fn=01;37:ln=32:bn=35:se=36'
# ms - matched characters on matched lines
# mc - matched characters on context lines (makes sense with -v)
# sl - unmatched characters on matched lines
# cx - unmatched characters on context lines
# fn - filenames (at beginning of output lines)
# ln - line numbers (at beginning of output lines)
# bn - byte offsets (at beginning of output lines)
# se - separators after filenames and line numbers, and between context blocks (i.e. ':' '-' '--')

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -alF'
#alias la='ls -A'
#alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f $HOME/.bash_aliases ]; then
    . $HOME/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# only on the desktop VM
if [ -d $HOME/pass ]; then
    export PASSWORD_STORE_DIR=$HOME/pass
fi

# added by Miniconda3 4.3.11 installer
if [ -d $HOME/bin/miniconda3/bin ]; then
    export PATH="/home/falko/bin/miniconda3/bin:$PATH"
fi

# source functions and aliases from other files
SOURCE_FILES="$HOME/.dotfiles"
for dotfile in .cluster_src .qumulo_src .salt_src .stornext_src .rsync_src .reporting_src; do
    file="${SOURCE_FILES}/${dotfile}"

    if [[ -f $file ]]; then
        echo "Sourcing $file"
        . $file
    fi
done
