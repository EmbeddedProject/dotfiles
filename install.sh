#!/bin/sh

rel_root=$(python -c "import os.path; print os.path.relpath('$(pwd)', '$HOME')")

for file in bashrc bash_aliases inputrc vim vimrc gitconfig gitfiles hgrc hgfiles
do
	ln -sf $rel_root/$file ~/.$file
done

mkdir -p ~/bin
for script in acked-by ctags-global ctags-local
do
	ln -sf ../$rel_root/bin/$script ~/bin/$script
done
