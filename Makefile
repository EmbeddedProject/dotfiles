HERE := $(shell readlink -ve .)
REL_ROOT := $(shell python -c "import os.path; print os.path.relpath('$(HERE)', '$(HOME)')")

.PHONY: all
all: install

.PHONY: install
install:

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
DOTFILES += vimrc
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

LESSUSEMOUSE := $(shell strings /usr/local/bin/less 2>&1 | grep -c LESSUSEMOUSE)

ifeq ($(LESSUSEMOUSE),0)
install: /usr/local/bin/less

LESS_URL := http://www.greenwoodsoftware.com/less/less-481.tar.gz
LESS_ARCH := less-481.tar.gz
LESS_DIR := less-481

/usr/local/bin/less: $(LESS_DIR)/less
	sudo $(MAKE) -C $(LESS_DIR) install

$(LESS_DIR)/less: $(LESS_DIR)/Makefile
	$(MAKE) -C $(LESS_DIR) -j

$(LESS_DIR)/Makefile: $(LESS_DIR)/configure
	cd $(LESS_DIR); ./configure

$(LESS_DIR)/configure: $(LESS_ARCH)
	tar -xf $(LESS_ARCH)
	chmod u+w -R $(LESS_DIR)
	patch -d $(LESS_DIR) -p1 < 0001-less-mouse-support.patch

$(LESS_ARCH):
	wget $(LESS_URL)
endif
