.PHONY: install
install:

DOTFILES := Xmodmap
DOTFILES += Xresources
DOTFILES += bash_aliases
DOTFILES += bashrc
DOTFILES += colordiffrc
DOTFILES += gitconfig
DOTFILES += gtkrc-2.0
DOTFILES += inputrc
DOTFILES += mostrc
DOTFILES += muttrc
DOTFILES += notion
DOTFILES += screenrc
DOTFILES += vim
DOTFILES += wallpaper.jpg
DOTFILES += xsessionrc

install: $(addprefix $(HOME)/.,$(DOTFILES))

$(HOME)/.%: %
	@ ! test -e "$@" || rm -rf -- "$@"
	@ ln -srvf "$<" "$@"

BINFILES := auto_away.py
BINFILES += backup.sh
BINFILES += ctags-global
BINFILES += ctags-local
BINFILES += gitweb.perl
BINFILES += haste
BINFILES += mutt-ldap-search.py
BINFILES += pr_activity.py
BINFILES += redemo.py
BINFILES += lessterm.sh

install: $(HOME)/bin | $(addprefix $(HOME)/bin/,$(BINFILES))

$(HOME)/bin $(HOME)/.gnupg $(HOME)/.local/share/applications $(HOME)/.config/fontconfig:
	@ mkdir -pv "$@"

$(HOME)/bin/%: bin/%
	@ ! test -e "$@" || rm -rf -- "$@"
	@ ln -srvf "$<" "$@"

GNUPGFILES := gpg.conf
GNUPGFILES += gpg-agent.conf

install: $(HOME)/.gnupg | $(addprefix $(HOME)/.gnupg/,$(GNUPGFILES))

$(HOME)/.gnupg/%: gnupg/%
	@ ! test -e "$@" || rm -rf -- "$@"
	@ ln -srvf "$<" "$@"
	@ chmod -c 600 "$<" "$@"

XDGFILES := defaults.list
XDGFILES += evince-previewer.desktop
XDGFILES += lessterm.desktop

install: $(HOME)/.local/share/applications | $(addprefix $(HOME)/.local/share/applications/,$(XDGFILES))

$(HOME)/.local/share/applications/%: xdg/%
	@ ! test -e "$@" || rm -rf -- "$@"
	@ ln -srvf "$<" "$@"

install: $(HOME)/.config/fontconfig |  $(HOME)/.config/fontconfig/fonts.conf

$(HOME)/.config/fontconfig/fonts.conf: fonts.conf
	@ ! test -e "$@" || rm -rf -- "$@"
	@ ln -srvf "$<" "$@"
