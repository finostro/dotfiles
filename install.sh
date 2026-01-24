#!/bin/bash
#neovim unstable 
sudo apt-get update
sudo apt-get install -y \
    software-properties-common
sudo add-apt-repository ppa:neovim-ppa/unstable

sudo apt-get update
sudo apt-get install -y \
    build-essential \
    cmake \
    curl \
    gettext \
    git \
    nala \
    neovim \
    ninja-build \
    python3-venv \
    ripgrep \
    software-properties-common \
    stow \
    tmux \
    unzip \
    zsh 


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

python3 -m venv ${HOME}/venv  --system-site-packages
source ${HOME}/venv/bin/activate
pip install -U pip 
# colcon-core and setuptools have weird dependency versions
if [ $ROS_DISTRO == "humble" ] ;  then
    pip install -U setuptools colcon-core  'cmake<4' 
else
    pip install -U setuptools colcon-core  cmake
fi

# install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_$(uname -m | sed s/aarch64/arm64/).tar.gz"
mkdir -p ~/.local/bin
tar xf lazygit.tar.gz --directory=$HOME/.local/bin lazygit
rm lazygit.tar.gz

# install npm
if [[ $# == 1  && $1 == '--all' ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    source ~/.nvm/nvm.sh
    nvm install node
fi

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
        echo "Could not find npm or cargo, getting binary file"
        TREESITTER_VERSION=$(curl -s "https://api.github.com/repos/tree-sitter/tree-sitter/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
        mkdir -p ~/.local/bin
        curl -L "https://github.com/tree-sitter/tree-sitter/releases/download/v${TREESITTER_VERSION}/tree-sitter-linux-$(uname -m | sed s/aarch64/arm64/ | sed s/x86_64/x64/).gz" | gzip -d > ~/.local/bin/tree-sitter
        chmod +x ~/.local/bin/tree-sitter
    fi
fi


# tmux plugins
git clone --depth 1 https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all


#install neovim plugins
nvim --headless "+Lazy! sync" +qa

#installing dotfiles
cd  ${HOME}/dotfiles
stow --adopt --ignore=install.sh .
git checkout .

#installing antidote
git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote


#run zsh to install plugins
zsh -c 'source ~/.zshrc'


# optionals 

if [[ $# == 1  && $1 == '--all' ]]; then
    
    #install rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y 

    #install  zig 
    sudo snap install zig --classic --beta
fi
