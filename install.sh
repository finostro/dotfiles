#!/bin/bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y \
    tmux \
    zsh \
    stow \
    ninja-build \
    gettext \
    cmake \
    unzip \
    curl \
    git \
    build-essential \
    software-properties-common \
    python3-venv

# install ros2 

if [[ ! -d /opt/ros ]]; then
    echo "Installing ros2"
    sudo add-apt-repository universe
    # setup ros2 apt source
    export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
    curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb" # If using Ubuntu derivates use $UBUNTU_CODENAME
    sudo dpkg -i /tmp/ros2-apt-source.deb
    sudo apt-get update 

      source /etc/os-release

      # Map Ubuntu version to ROS 2 distro
      case "$VERSION_ID" in
        "20.04") ROS_DISTRO="foxy" ;;
        "22.04") ROS_DISTRO="humble" ;;
        "24.04") ROS_DISTRO="jazzy" ;;
        *)       ROS_DISTRO="" ;;
      esac

      if [ -n "$ROS_DISTRO" ]; then
          echo "Installing ROS 2 $ROS_DISTRO"
          sudo apt-get install -y ros-$ROS_DISTRO-desktop
          sudo rosdep init
          rosdep update
      fi
fi


sudo apt-get install -y \
    python3-vcstool \
    ros-dev-tools

python3 -m venv ${HOME}/default_venv --system-site-packages

# install npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.nvm/nvm.sh
nvm install node

# setup argcomplete for older ubuntus
if [ ! -f /usr/bin/register-python-argcomplete ]; then
    if [ -f /usr/bin/register-python-argcomplete3 ]; then
        sudo ln -s /usr/bin/register-python-argcomplete3 /usr/bin/register-python-argcomplete
    else
        echo "Could not find register-python-argcomplete3"
    fi 
fi

# tree-sitter-cli is required for nvim vimtex plugin
if ! command -v tree-sitter &> /dev/null; then
    echo "Installing tree-sitter"
    if command -v npm &> /dev/null; then
        npm install -g tree-sitter-cli
    elif command -v cargo &> /dev/null; then
        cargo install tree-sitter-cli
    else
        echo "Could not find npm or cargo, could not install tree-sitter-cli"
    fi
fi


# tmux plugins
git clone --depth 1 https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all

# neovim setup
cd 
git clone --depth 1 https://github.com/neovim/neovim 
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
git clone --depth 1 https://github.com/finostro/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
nvim --headless "+Lazy! sync" +qa

#installing dotfiles
cd  ${HOME}/dotfiles
stow --adopt --ignore=install.sh .
git checkout .

#run zsh to install plugins
zsh -c 'source ~/.zshrc'


# optionals 

if [[ $# == 1  && $1 == '--all' ]]; then
    
    #install rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y 

    #install  zig 
    sudo snap install zig --classic --beta
fi
