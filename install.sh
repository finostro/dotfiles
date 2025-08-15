
sudo apt-get update
sudo apt-get install -y \
    python3-vcstool \
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
    python3-venv

python3 -m venv ${HOME}/default_venv --system-site-packages


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
$HOME/.fzf/install

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
stow --ignore=install.sh .

#run zsh to install plugins
zsh -c 'source ~/.zshrc'


