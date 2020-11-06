.PHONY: install
install:

REL_ROOT := $(shell python -c "import os.path; print os.path.relpath('$(CURDIR)', '$(HOME)')")

DOTFILES := Xmodmap
DOTFILES += Xresources
DOTFILES += bash_aliases
DOTFILES += bashrc
DOTFILES += colordiffrc
DOTFILES += gitconfig
DOTFILES += gitfiles
DOTFILES += gtkrc-2.0
DOTFILES += goobookrc
DOTFILES += inputrc
DOTFILES += mostrc
DOTFILES += muttrc
DOTFILES += notion
DOTFILES += vim
DOTFILES += vrapperrc
DOTFILES += wallpaper.jpg
DOTFILES += xsessionrc

install: $(addprefix $(HOME)/.,$(DOTFILES))

$(HOME)/.%: %
	@ ! test -e "$@" || rm -rf -- "$@"
	@ echo '$@ -> $(REL_ROOT)/$<'
	@ ln -sf "$(REL_ROOT)/$<" "$@"

BINFILES := auto_away.py
BINFILES += backup.sh
BINFILES += ctags-global
BINFILES += ctags-local
BINFILES += haste
BINFILES += mutt-ldap-search.py
BINFILES += pr_activity.py
BINFILES += redemo.py
BINFILES += lessterm.sh

install: $(HOME)/bin | $(addprefix $(HOME)/bin/,$(BINFILES))

$(HOME)/bin $(HOME)/.gnupg $(HOME)/.local/share/applications:
	mkdir -p "$@"

$(HOME)/bin/%: bin/%
	@ ! test -e "$@" || rm -rf -- "$@"
	@ echo '$@ -> ../$(REL_ROOT)/$<'
	@ ln -sf "../$(REL_ROOT)/$<" "$@"

GNUPGFILES := gpg.conf
GNUPGFILES += gpg-agent.conf
GNUPGFILES += pubring.gpg
GNUPGFILES += pubring.kbx
GNUPGFILES += trustdb.gpg

install: $(HOME)/.gnupg | $(addprefix $(HOME)/.gnupg/,$(GNUPGFILES))

$(HOME)/.gnupg/%: gnupg/%
	@ ! test -e "$@" || rm -rf -- "$@"
	@ echo '$@ -> ../$(REL_ROOT)/$<'
	@ ln -sf "../$(REL_ROOT)/$<" "$@"
	@ chmod -c 600 "$<" "$@"

XDGFILES := defaults.list
XDGFILES += evince-previewer.desktop
XDGFILES += lessterm.desktop

install: $(HOME)/.local/share/applications | $(addprefix $(HOME)/.local/share/applications/,$(XDGFILES))

$(HOME)/.local/share/applications/%: xdg/%
	@ ! test -e "$@" || rm -rf -- "$@"
	@ echo '$@ -> ../../../$(REL_ROOT)/$<'
	@ ln -sf "../../../$(REL_ROOT)/$<" "$@"
