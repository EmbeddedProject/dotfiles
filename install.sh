#!/bin/sh

echo "dotfiles root: $(pwd)"
rel_root=$(python -c "import os.path; print os.path.relpath('$(pwd)', '$HOME')")

for file in bashrc bash_aliases inputrc vim vimrc vrapperrc gitconfig gitfiles hgrc hgfiles Xmodmap
do
	ln -sfv $rel_root/$file ~/.$file
done

mkdir -p ~/bin
for script in acked-by ctags-global ctags-local redemo.py
do
	ln -sfv ../$rel_root/bin/$script ~/bin/$script
done
