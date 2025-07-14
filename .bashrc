# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
#case $- in
#    *i*) ;;
#      *) return;;
#esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

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
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
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
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
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

#export NINJAJOBS=12
#export CMAKE_GENERATOR=Ninja


# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

#export CC=/usr/bin/clang-12
#export CXX=/usr/bin/clang++-12
#source ~/Code/ros2_eloquent/install/setup.bash
#source /opt/ros/noetic/setup.bash 
#source ~/Code/sim_ws/install/setup.bash
#source ~/Code/cartographer_ws/devel_isolated/setup.bash
#source ~/Code/nav_ws/devel/setup.bash
#source ~/Code/ks_no_submodules/devel/setup.bash
#source ~/Code/el5206_ws/devel/setup.bash
#source ~/Code/hglmb_ws/devel/setup.bash
# source /opt/ros/humble/setup.bash
#source ~/code/ks2_ws/install/setup.bash
#source ~/Code/amtc_ws/devel/setup.bash

#export ROS_LOCALHOST_ONLY=1
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export RCUTILS_COLORIZED_OUTPUT=1
export RCUTILS_CONSOLE_OUTPUT_FORMAT="[{severity} {time}] [{name}]: {message} ({function_name}() at {file_name}:{line_number})"
export FASTRTPS_DEFAULT_PROFILES_FILE=/home/finostro/fastrtps_interface_restriction.xml
export CYCLONEDDS_URI=file://$PWD/cyclone.xml

export   SIMULATION_WS_SETUP_FILE=/home/finostro/Code/sim_ws/install/setup.bash
export   ROS_2_WS_SETUP_FILE=/home/finostro/Code/ks/ros2_ws/install/setup.bash
export   BRIDGE_WS_SETUP_FILE=/home/finostro/Code/ks/bridge_ws/install/setup.bash

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/finostro/Code/google-cloud/google-cloud-sdk/path.bash.inc' ]; then . '/home/finostro/Code/google-cloud/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command complettion for gcloud.
if [ -f '/home/finostro/Code/google-cloud/google-cloud-sdk/completion.bash.inc' ]; then . '/home/finostro/Code/google-cloud/google-cloud-sdk/completion.bash.inc'; fi

# vcs-tool autocompletion
source /usr/share/vcstool-completion/vcs.bash

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/home/finostro/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/home/finostro/anaconda3/etc/profile.d/conda.sh" ]; then
#        . "/home/finostro/anaconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/home/finostro/anaconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<

#. "$HOME/.cargo/env"
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
