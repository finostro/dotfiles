
sudo apt-get update
sudo apt-get install -y \
    python3-vcstool \
    tmux \
    zsh \
    stow \
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
    elseif command -v cargo &> /dev/null; then
        cargo install tree-sitter-cli
    else
        echo "Could not find npm or cargo, could not install tree-sitter-cli"
    fi
fi


# tmux plugins
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# neovim setup
git clone https://github.com/finostro/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
nvim --headless "+Lazy! sync" +qa

#installing dotfiles
cd  ${HOME}/dotfiles
stow --ignore=install.sh .

#run zsh to install plugins
zsh -c 'source ~/.zshrc'


