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

# download Cica font
mkdir -p /tmp/Cica
pushd /tmp/Cica
curl -s https://api.github.com/repos/miiton/Cica/releases/latest \
    | grep browser_download_url \
    | grep with_emoji.zip \
    | cut -d '"' -f 4 \
    | wget -qi - 
unzip Cica_v*_with_emoji.zip
mkdir -p ~/.font
mv Cica-Bold.ttf Cica-BoldItalic.ttf Cica-Regular.ttf Cica-RegularItalic.ttf ~/.font
fc-cache -fv
cd /tmp
rm -rf Cica
popd
