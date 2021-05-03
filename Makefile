# Copyright 2021 Robin Jarry

.PHONY: install
install: dotfiles scripts
	@:

.PHONY: help
help:
	@echo "Bonjour, this is Robin config repo."
	@echo
	@echo "The following targets are available:"
	@echo
	@echo "  dotfiles       install user config files"
	@echo "  scripts        install user scripts in ~/bin"
	@echo "  deb            install system deb packages"
	@echo "  help           show this help message"
	@echo

DOTFILES := Xmodmap
DOTFILES += Xresources
DOTFILES += bash_aliases
DOTFILES += bashrc
DOTFILES += colordiffrc
DOTFILES += gitconfig
DOTFILES += gtkrc-2.0
DOTFILES += i3
DOTFILES += i3status.conf
DOTFILES += inputrc
DOTFILES += mostrc
DOTFILES += muttrc
DOTFILES += notion
DOTFILES += screenrc
DOTFILES += tmux.conf
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
	@:

$(HOME)/.%: %
	@! [ -e $@ ] || rm -rf -- $@
	@mkdir -pv $(@D)
	@ln -srvf $< $@
	@! [ $(@D) = $(HOME)/.gnupg ] || chmod -c 600 $< $@

BINFILES := gitweb.perl
BINFILES += haste
BINFILES += mutt-ldap-search.py
BINFILES += pr_activity.py
BINFILES += inputplug.sh
BINFILES += redemo.py
BINFILES += yank

.PHONY: scripts
scripts: $(addprefix $(HOME)/bin/,$(BINFILES))
	@:

$(HOME)/bin/%: bin/%
	@! [ -e $@ ] || rm -rf -- $@
	@mkdir -pv $(@D)
	@ln -srvf $< $@

DEBS += bash
DEBS += cscope
DEBS += curl
DEBS += dbus-user-session
DEBS += dunst
DEBS += feh
DEBS += firefox
DEBS += fonts-terminus
DEBS += fzf
DEBS += git
DEBS += grep
DEBS += gzip
DEBS += hexchat
DEBS += htop
DEBS += inputplug
DEBS += ipython3
DEBS += libnotify-bin
DEBS += lz4
DEBS += nm-tray
DEBS += notion
DEBS += numlockx
DEBS += ripgrep
DEBS += rsync
DEBS += screen
DEBS += source-highlight
DEBS += suckless-tools
DEBS += tmux
DEBS += tree
DEBS += xbacklight
DEBS += xfonts-terminus
DEBS += xserver-xorg-input-synaptics
DEBS += xss-lock
DEBS += xterm

.PHONY: deb
deb:
	sudo apt update
	sudo apt install $(DEBS)
