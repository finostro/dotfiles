# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zmodload zsh/zprof

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

export PATH=$HOME/.local/bin:/HOME/bin:/usr/local/bin:$PATH

# syntax highlighting
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
# Load powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k


#key bindings

bindkey '^y' autosuggest-accept
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
export ROS_LOCALHOST_ONLY=1
export CYCLONEDDS_URI=file://$HOME/cyclone.xml
# source /opt/ros/humble/local_setup.zsh

# Auto-source ROS 2 based on Ubuntu version and installed distro
if [ -f /etc/os-release ]; then
  source /etc/os-release

  # Map Ubuntu version to ROS 2 distro
  case "$VERSION_ID" in
    "20.04") ROS_DISTRO="foxy" ;;
    "22.04") ROS_DISTRO="humble" ;;
    "24.04") ROS_DISTRO="rolling" ;;
    *)       ROS_DISTRO="" ;;
  esac

  if [ -n "$ROS_DISTRO" ]; then
    ROS_SETUP="/opt/ros/$ROS_DISTRO/local_setup.zsh"
    if [ -f "$ROS_SETUP" ]; then
      source "$ROS_SETUP"
    else
      echo "Warning: ROS 2 setup file not found at $ROS_SETUP"
    fi
  else
    echo "Warning: No ROS 2 distro mapped for Ubuntu $VERSION_ID"
  fi
fi


source ~/.aliases
source /usr/share/vcstool-completion/vcs.zsh
# source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.zsh
# # echo 'argcomplete'
#
eval "$(register-python-argcomplete ros2)"
eval "$(register-python-argcomplete colcon)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# eval "$(starship init zsh)"
# zprof

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
