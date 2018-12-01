# ~/.bashrc: executed by bash(1) for non-login shells.

#TODO what now?
# source /etc/bashrc before interactive check for ssh -t cluster-dev qlogin
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

### constants
export VISUAL=vim

REPOS_DIR="${HOME}/repos"
TOOLS_DIR="${REPOS_DIR}/dotfiles/tools"

# Who/what am I
default_perms=$(umask -S | sed 's/[ugo]=\(r*\)\(w*\)\(x*\)/@\1@#\2#%\3%/g' | sed 's/\(.\)\1/-/g' | tr -d  ',@#%')
effective_group=$(id -gn)

#TODO should be a function or alias
echo
echo "$default_perms $USER:$effective_group"
echo

# Use bash-completion, if available
#TODO re-write this as a proper if statement
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . "/usr/share/bash-completion/bash_completion"

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
    if (( $(id -u) == 0 || $(id -u) == $ADMIN_UID )); then
        #"root" prompt colors username red and replaces $ with a red #
        PS1='\n\T \[\e[91m\]\u\[\e[32m\]@\h:\[\e[33m\]\w\[\e[91m\]#\[\e[0m\] '
        echo "Remember: \"With root power comes root responsibility.\""
    else
        PS1='\n\T \[\e[32m\]\u@\h:\[\e[33m\]\w\[\e[0m\]\$ '
    fi
fi

#TODO untangle all the color prompt stuff
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
#TODO Does this work for other OSs?
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac

# enable color support of ls and also add handy aliases
if [[ -x /usr/bin/dircolors ]]; then
    if [[ -f $HOME/.dircolors ]]; then
        # set dircolors from global config file
        eval "$(dircolors -b)"
        # append dircolors from our config file
        eval "$(dircolors -b $HOME/.dircolors | sed 's/^LS_COLORS=/LS_COLORS=$LS_COLORS:/')"
    fi

    alias ls='ls -hF --color=auto'	#human-readable, append type indicator character

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [[ -f "${HOME}/.alias" ]]; then
    . "${HOME}/.alias"
fi

if [[ -f "${HOME}/.function" ]]; then
    . "${HOME}/.function"
fi

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
#TODO look into this
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

#TODO check on this stuff
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

#TODO pull these out into separate dotfiles

### vise - home VM
if [[ $HOSTNAME == "vise" ]]; then
    # github auth token for the 'hub' command
    GITHUB_TOKEN=$(git config hub.token)
    export GITHUB_TOKEN
fi

### daly - work VM
if [[ $HOSTNAME == "daly" ]]; then
    export PASSWORD_STORE_DIR="${REPOS_DIR}/pass"

    # UIDs and GIDs
    DEFAULT_GROUP="Domain Users" # IHME default group
    INFR_GROUP="ihme-infr"       # my normal effective group
    ADMIN_UID=700718             # my admin account
    ADMIN_GROUP="IHME-SA"        # admin account effective group

    effective_group="$INFR_GROUP"

    # Determine which effective group to use
    if (( $(id -u) == ADMIN_UID )); then
        effective_group="$ADMIN_GROUP"
    fi

    # try to set effective group
    # don't overwrite effective group if already newgrp'd to something else
    if [[ $(id -gn) = "$DEFAULT_GROUP" ]]; then
        exec newgrp $effective_group
    else
        echo "Accepting existing non-default group"
    fi
fi

# added by Miniconda3 4.3.11 installer
if [[ -d $HOME/bin/miniconda3/bin ]]; then
    export PATH="/home/falko/bin/miniconda3/bin:$PATH"
fi

# source functions and aliases from other files
for tool_src in {TOOLS_DIR}/*; do
    if [[ -f "$tool_src" ]]; then
        . "$tool_src"
    fi
done
