# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
if [ -f ~/.local/share/omarchy/default/bash/rc ] ; then
	source ~/.local/share/omarchy/default/bash/rc
fi

if [ -f ~/.aliases ] ; then 
	source ~/.aliases
fi

if [ -f ~/jetson_aliases.sh ] ; then 
	source ~/jetson_aliases.sh
fi

if [ -f ~/.ros_setup_rc.sh ] ; then 
	source ~/.ros_setup_rc.sh
fi
# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'



# vcs-tool autocompletion
source /usr/share/vcstool-completion/vcs.bash

source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
source ~/venv/bin/activate
source /opt/ros/jazzy/setup.bash

