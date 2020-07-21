#!/bin/bash

ln -sf ~/dotfiles/.screenrc ~/.screenrc
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.vim ~/.vim
mkdir -p ~/.vim/backup
mkdir -p ~/.vimundo
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zshenv ~/.zshenv
mkdir -p ~/.config/Code/User/
ln -sf ~/dotfiles/settings.json ~/.config/Code/User/settings.json
ln -sf ~/dotfiles/keybindings.json ~/.config/Code/User/keybindings.json
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/Dropbox/dotfiles/.zsh_history ~/.zsh_history
if [[ ! -d ~/.dircolors-solarized ]];then
    git clone --depth=1 https://github.com/micchy326/dircolors-solarized ~/.dircolors-solarized
fi
if [[ ! -d  ~/.powerlevel10k ]];then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
fi

pushd ~/.dircolors-solarized
git pull > /dev/null
popd
ln -sf ~/dotfiles/rkj-repos-custom.zsh-theme ~/.oh-my-zsh/custom/themes/

tic -x -o ~/.terminfo terminfo-24bit.src
