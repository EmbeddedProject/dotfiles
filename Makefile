# Copyright 2021 Robin Jarry

.PHONY: help
help:
	@echo "Bonjour, this is Robin config repo."
	@echo
	@echo "The following targets are available:"
	@echo
	@echo "  dotfiles       install user config files"
	@echo "  scripts        install user scripts in ~/bin"
	@echo "  install        all of the above"
	@echo "  help           show this help message"
	@echo

.PHONY: install dotfiles scripts
install: dotfiles scripts
	:

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
DOTFILES += gnupg/gpg.conf
DOTFILES += gnupg/gpg-agent.conf
DOTFILES += local/share/applications/defaults.list
DOTFILES += local/share/applications/evince-previewer.desktop
DOTFILES += local/share/applications/lessterm.desktop
DOTFILES += config/fontconfig/fonts.conf

.PHONY: dotfiles
dotfiles: $(addprefix $(HOME)/.,$(DOTFILES))
	:

$(HOME)/.%: %
	@! [ -e $@ ] || rm -rf -- $@
	@mkdir -pv $(@D)
	@ln -srvf $< $@
	@! [ $(@D) = $(HOME)/.gnupg ] || chmod -c 600 $< $@

BINFILES := gitweb.perl
BINFILES += haste
BINFILES += mutt-ldap-search.py
BINFILES += pr_activity.py
BINFILES += redemo.py

.PHONY: scripts
scripts: $(addprefix $(HOME)/bin/,$(BINFILES))
	:

$(HOME)/bin/%: bin/%
	@! [ -e $@ ] || rm -rf -- $@
	@mkdir -pv $(@D)
	@ln -srvf $< $@
