#!/bin/bash

ln -s ~/dotfiles/.screenrc ~/.screenrc
mkdir -p ~/.vim/backup
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.vim ~/.vim
ln -s ~/dotfiles/.zshrc ~/.zshrc
mkdir -p ~/.config/Code/User/
ln -s ~/dotfiles/settings.json ~/.config/Code/User/settings.json
ln -s ~/dotfiles/keybindings.json ~/.config/Code/User/keybindings.json

