.PHONY: install
install:

HERE = $(shell readlink -ve .)
REL_ROOT = $(shell python -c "import os.path; print os.path.relpath('$(HERE)', '$(HOME)')")

DOTFILES := Xmodmap
DOTFILES += Xresources
DOTFILES += bash_aliases
DOTFILES += bashrc
DOTFILES += gitconfig
DOTFILES += gitfiles
DOTFILES += hgfiles
DOTFILES += hgrc
DOTFILES += inputrc
DOTFILES += mostrc
DOTFILES += notion
DOTFILES += vim
DOTFILES += vrapperrc
DOTFILES += wallpaper.jpg
DOTFILES += xsessionrc

install: $(addprefix $(HOME)/.,$(DOTFILES))

$(HOME)/.%: %
	@ ! test -e "$@" || rm -rf -- "$@"
	@ ln -sf "$(REL_ROOT)/$<" "$@"
	@ echo '$@ -> $(REL_ROOT)/$<'

BINFILES := auto_away.py
BINFILES += backup.sh
BINFILES += ctags-global
BINFILES += ctags-local
BINFILES += haste
BINFILES += redemo.py

install: $(HOME)/bin | $(addprefix $(HOME)/bin/,$(BINFILES))

$(HOME)/bin:
	mkdir -p "$@"

$(HOME)/bin/%: bin/%
	@ ! test -e "$@" || rm -rf -- "$@"
	@ ln -sf "../$(REL_ROOT)/$<" "$@"
	@ echo '$@ -> ../$(REL_ROOT)/$<'
