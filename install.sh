#!/bin/sh

here=$(dirname $(readlink -vf $0))
echo "dotfiles root: $here"
echo "home: $HOME"
rel_root=$(python -c "import os.path; print os.path.relpath('$here', '$HOME')")
echo "relative root: $rel_root"

dotfiles='
Xmodmap
Xresources
bash_aliases
bashrc
gitconfig
gitfiles
hgfiles
hgrc
inputrc
mostrc
notion
vim
vimrc
vrapperrc
xsessionrc
'
for f in $dotfiles; do
	[ -e ~/.$f ] && rm -rf ~/.$f
	ln -sfv $rel_root/$f ~/.$f
done

binfiles='
acked-by
auto_away.py
backup.sh
ctags-global
ctags-local
redemo.py
'
mkdir -p ~/bin
for f in $binfiles; do
	[ -e ~/bin/$f ] && rm -rf ~/bin/$f
	ln -sfv ../$rel_root/bin/$f ~/bin/$f
done
