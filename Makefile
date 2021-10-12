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

DOTFILES += Xmodmap
DOTFILES += Xresources
DOTFILES += bash_aliases
DOTFILES += bashrc
DOTFILES += colordiffrc
DOTFILES += config/dunst/dunstrc
DOTFILES += config/i3/config
DOTFILES += config/i3/lock.sh
DOTFILES += config/polybar/config
DOTFILES += config/polybar/launch.sh
DOTFILES += config/polybar/ssh-vpn-status.sh
DOTFILES += config/polybar/ssh-vpn-toggle.sh
DOTFILES += config/polybar/spotify.py
DOTFILES += config/polybar/irc_status.py
DOTFILES += gitconfig
DOTFILES += gnupg/gpg-agent.conf
DOTFILES += gnupg/gpg.conf
DOTFILES += gnupg/scdaemon.conf
DOTFILES += gtkrc-2.0
DOTFILES += inputrc
DOTFILES += local/share/applications/defaults.list
DOTFILES += local/share/applications/mupdf.desktop
DOTFILES += local/share/applications/lessterm.desktop
DOTFILES += local/share/icons/display-brightness.svg
DOTFILES += local/share/icons/volume-down.svg
DOTFILES += local/share/icons/volume-off.svg
DOTFILES += local/share/icons/volume-up.svg
DOTFILES += mostrc
DOTFILES += muttrc
DOTFILES += notion
DOTFILES += screenrc
DOTFILES += taskrc
DOTFILES += tmux.conf
DOTFILES += vim
DOTFILES += wallpaper.png
DOTFILES += xsessionrc
DOTFILES += xsettingsd

.PHONY: dotfiles
dotfiles: $(addprefix $(HOME)/.,$(DOTFILES))
	@:

$(HOME)/.%: %
	@! [ -e $@ ] || rm -rf -- $@
	@mkdir -pv $(@D)
	@ln -srvf $< $@
	@! [ $(@D) = $(HOME)/.gnupg ] || chmod -c 600 $< $@

BINFILES += ac-auto-backlight.sh
BINFILES += gitweb.perl
BINFILES += git-checkpatches
BINFILES += git-cifixes
BINFILES += git-people
BINFILES += haste
BINFILES += keyboard_stats.py
BINFILES += mutt-ldap-search.py
BINFILES += backlight.sh
BINFILES += pr_activity.py
BINFILES += inputplug.sh
BINFILES += redemo.py
BINFILES += volume

.PHONY: scripts
scripts: $(addprefix $(HOME)/bin/,$(BINFILES))
	@:

$(HOME)/bin/%: bin/%
	@! [ -e $@ ] || rm -rf -- $@
	@mkdir -pv $(@D)
	@ln -srvf $< $@

DEBS += brightnessctl
DEBS += cscope
DEBS += curl
DEBS += dbus-user-session
DEBS += dunst
DEBS += feh
DEBS += firefox-esr
DEBS += fonts-hack
DEBS += fonts-terminus
DEBS += fzf
DEBS += git
DEBS += gnupg
DEBS += hexchat
DEBS += htop
DEBS += i3
DEBS += i3lock
DEBS += imagemagick
DEBS += inotify-tools
DEBS += inputplug
DEBS += ipython3
DEBS += libnotify-bin
DEBS += network-manager-gnome
DEBS += nm-tray
DEBS += numlockx
DEBS += polybar
DEBS += ripgrep
DEBS += rofi
DEBS += rsync
DEBS += source-highlight
DEBS += taskwarrior
DEBS += tmux
DEBS += tree
DEBS += vim-nox
DEBS += xfonts-terminus
DEBS += xinput
DEBS += xss-lock
DEBS += xterm

.PHONY: deb
deb:
	sudo apt update
	sudo apt install $(DEBS)
