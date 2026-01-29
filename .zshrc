# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zmodload zsh/zprof


ANTIDOTE_HOME=${ZDOTDIR:-$HOME}/.antidote
ZSH_PLUGINS=${ZDOTDIR:-$HOME}/.zsh_plugins

export NVM_LAZY_LOAD=true
export NVM_DIR="$HOME/.nvm"



# if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
#  compinit -d ~/.zcompdump
# else
#  compinit -d ~/.zcompdump
# fi

# Lazy-load antidote from its functions directory.
fpath=(${ANTIDOTE_HOME}/functions $fpath)
autoload -Uz antidote

if [[ ! ${ZSH_PLUGINS}.zsh -nt ${ZSH_PLUGINS}.txt ]]; then
  (
    source ${ANTIDOTE_HOME}/antidote.zsh
    antidote bundle <${ZSH_PLUGINS}.txt >${ZSH_PLUGINS}.zsh
  )
fi
source ${ZSH_PLUGINS}.zsh

export PATH=$HOME/.local/bin:/HOME/bin:/usr/local/bin:$HOME/go/bin:/usr/local/go/bin:$PATH
export EDITOR=nvim



#key bindings

bindkey '^y' autosuggest-accept
bindkey '^R' history-incremental-search-backward
#Shared history options
#
setopt appendhistory
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
HISTDUP=erase



export PATH="${PATH}:$HOME/.config/emacs/bin"
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
# export ROS_LOCALHOST_ONLY=1
export ROS_DOMAIN_ID=80
export ROS_AUTOMATIC_DISCOVERY_RANGE=LOCALHOST
export CYCLONEDDS_URI=file://$HOME/cyclone.xml
# source /opt/ros/humble/setup.zsh



source ~/.aliases
source /usr/share/vcstool-completion/vcs.zsh
# source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.zsh
# # echo 'argcomplete'
#
# eval "$(register-python-argcomplete ros2)"
# eval "$(register-python-argcomplete colcon)"

#CUDA
export CUDA_HOME=/usr/local/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

# source <(fzf --zsh)

# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ~/venv/bin/activate

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#GIT
export GIT_SSH_KEY_PATH=~/.ssh/id_ed25519.pub

autoload -Uz compinit
compinit  -C
# Auto-source ROS 2 based on Ubuntu version and installed distro
if [[ -f $HOME/.ros_setup_rc.sh ]] ; then 
  compinit() {return 0}
  source $HOME/.ros_setup_rc.sh
  unfunction compinit
elif [[ -d /opt/ros ]] ; then
  distros=$(find "/opt/ros" -mindepth 1 -maxdepth 1)
  if [[ $(echo "$distros" | wc -l)==1 ]] ; then
    ROS_DISTRO=$(basename $distros)
  elif [ -f /etc/os-release ]; then
    source /etc/os-release

    # Map Ubuntu version to ROS 2 distro
    case "$VERSION_ID" in
      "20.04") ROS_DISTRO="foxy" ;;
      "22.04") ROS_DISTRO="humble" ;;
      "24.04") ROS_DISTRO="jazzy" ;;
      *)       ROS_DISTRO="" ;;
    esac
  fi

  if [ -n "$ROS_DISTRO" ]; then
    ROS_SETUP="/opt/ros/$ROS_DISTRO/setup.zsh"
    if [ -f "$ROS_SETUP" ]; then
      compinit() {return 0}
      source "$ROS_SETUP"
      unfunction compinit
    else
      echo "Warning: ROS 2 setup file not found at $ROS_SETUP"
    fi
  else
    echo "Warning: No ROS 2 distro mapped for Ubuntu $VERSION_ID"
  fi
fi
# zprof
