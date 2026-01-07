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

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export RCUTILS_COLORIZED_OUTPUT=1
export RCUTILS_CONSOLE_OUTPUT_FORMAT="[{severity} {time}] [{name}]: {message} ({function_name}() at {file_name}:{line_number})"
export CYCLONEDDS_URI=file://$HOME/cyclone.xml


# vcs-tool autocompletion
source /usr/share/vcstool-completion/vcs.bash

source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

