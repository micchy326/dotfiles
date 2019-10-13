#!/bin/bash

ln -sf ~/dotfiles/.screenrc ~/.screenrc
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.vim ~/.vim
mkdir -p ~/.vim/backup
ln -sf ~/dotfiles/.zshrc ~/.zshrc
mkdir -p ~/.config/Code/User/
ln -sf ~/dotfiles/settings.json ~/.config/Code/User/settings.json
ln -sf ~/dotfiles/keybindings.json ~/.config/Code/User/keybindings.json
if [[ ! -d ~/.dircolors-solarized ]];then
    git clone https://github.com/seebi/dircolors-solarized.git ~/.dircolors-solarized
fi

pushd ~/.dircolors-solarized
git pull > /dev/null
popd
ln -sf ~/dotfiles/rkj-repos-custom.zsh-theme ~/.oh-my-zsh/custom/themes/

tic -x -o ~/.terminfo terminfo-24bit.src
