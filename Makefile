# Copyright 2021 Robin Jarry

.PHONY: help
help:
	@echo "Bonjour, this is Robin config files."
	@echo
	@echo "The following targets are available:"
	@echo
	@echo "  install        install user config files and scripts"
	@echo "  dotfiles       install user config files"
	@echo "  scripts        install user scripts in ~/bin"
	@echo "  deb            install system deb packages"
	@echo "  help           show this help message"
	@echo

.PHONY: install
install: dotfiles scripts
	@:

xdg_config := $(shell find config/ -type f)
xdg_local := $(shell find local/ -type f)

DOTFILES += Xmodmap
DOTFILES += Xresources
DOTFILES += bash_aliases
DOTFILES += bashrc
DOTFILES += colordiffrc
DOTFILES += $(xdg_config)
DOTFILES += gitconfig
DOTFILES += gnupg/gpg-agent.conf
DOTFILES += gnupg/gpg.conf
DOTFILES += gnupg/scdaemon.conf
DOTFILES += gtkrc-2.0
DOTFILES += inputrc
DOTFILES += $(xdg_local)
DOTFILES += mostrc
DOTFILES += muttrc
DOTFILES += sbuildrc
DOTFILES += screenrc
DOTFILES += taskrc
DOTFILES += tmux.conf
DOTFILES += vim
DOTFILES += wallpaper.png
DOTFILES += xkb/symbols/fr-devel
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

BINFILES = $(wildcard bin/*)

.PHONY: scripts
scripts: $(addprefix $(HOME)/,$(BINFILES))
	@:

$(HOME)/bin/%: bin/%
	@! [ -e $@ ] || rm -rf -- $@
	@mkdir -pv $(@D)
	@ln -srvf $< $@

DEBS += brightnessctl
DEBS += clementine
DEBS += cscope
DEBS += curl
DEBS += deepin-screenshot
DEBS += dbus-user-session
DEBS += dunst
DEBS += feh
DEBS += debianutils
DEBS += firefox-esr
DEBS += fonts-font-awesome
DEBS += fonts-symbola
DEBS += fonts-terminus
DEBS += fzf
DEBS += git
DEBS += gnupg
DEBS += golang
DEBS += gopls
DEBS += grimshot
DEBS += hexchat
DEBS += htop
DEBS += i3
DEBS += i3lock
DEBS += imagemagick
DEBS += inotify-tools
DEBS += inputplug
DEBS += ipython3
DEBS += kanshi
DEBS += laptop-detect
DEBS += libnotify-bin
DEBS += lsof
DEBS += mako-notifier
DEBS += mpc
DEBS += mpd
DEBS += neovim
DEBS += network-manager-gnome
DEBS += nm-tray
DEBS += numlockx
DEBS += pcscd
DEBS += polybar
DEBS += playerctl
DEBS += pulseaudio
DEBS += pulsemixer
DEBS += python-is-python3
DEBS += python3-dbus
DEBS += python3-i3ipc
DEBS += qtwayland5
DEBS += ripgrep
DEBS += rofi
DEBS += rsync
DEBS += scdaemon
DEBS += scdoc
DEBS += slurp
DEBS += source-highlight
DEBS += strace
DEBS += sway
DEBS += swayidle
DEBS += swaylock
DEBS += taskwarrior
DEBS += tlp
DEBS += tmux
DEBS += tree
DEBS += vim-nox
DEBS += x11-xserver-utils
DEBS += waybar
DEBS += wev
DEBS += wl-clipboard
DEBS += wofi
DEBS += xfonts-terminus
DEBS += xinput
DEBS += xss-lock
DEBS += xterm
DEBS += xwayland

.PHONY: deb
deb:
	sudo apt update
	sudo apt install $(DEBS)
