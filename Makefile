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
	@echo "  rpm            install system rpm packages"
	@echo "  help           show this help message"
	@echo

.PHONY: install
install: dotfiles scripts
	@:

.PHONY: uninstall
uninstall: uninstall-dotfiles uninstall-scripts
	@:

xdg_config := $(shell find config/ -type f)
xdg_local := $(shell find local/ -type f)

DOTFILES += Xmodmap
DOTFILES += Xresources
DOTFILES += bash_aliases
DOTFILES += bash_profile
DOTFILES += bashrc
DOTFILES += colordiffrc
DOTFILES += dir_colors
DOTFILES += $(xdg_config)
DOTFILES += gdbinit
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
DOTFILES += tmate.conf
DOTFILES += tmux.conf
DOTFILES += vim
DOTFILES += wallpaper.png
DOTFILES += xkb/symbols/fr-devel
DOTFILES += xsessionrc
DOTFILES += xsettingsd
DOTFILES += zprofile
DOTFILES += zshrc

.PHONY: dotfiles
dotfiles: $(addprefix $(HOME)/.,$(DOTFILES))
	@:

$(HOME)/.%: %
	@! [ -e $@ ] || rm -rf -- $@
	@mkdir -pv $(@D)
	@ln -srvf $< $@
	@! [ $(@D) = $(HOME)/.gnupg ] || chmod -c 600 $< $@

.PHONY: uninstall-dotfiles
uninstall-dotfiles:
	@$(foreach f,$(addprefix $(HOME)/.,$(DOTFILES)), rm -fv $f;)

BINFILES = $(wildcard bin/*)

.PHONY: scripts
scripts: $(addprefix $(HOME)/,$(BINFILES))
	@:

$(HOME)/bin/%: bin/%
	@! [ -e $@ ] || rm -rf -- $@
	@mkdir -pv $(@D)
	@ln -srvf $< $@

.PHONY: uninstall-scripts
uninstall-scripts:
	@$(foreach f,$(addprefix $(HOME)/,$(BINFILES)), rm -fv $f;)

DEBS += bat
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

RPMS += NetworkManager-openvpn-gnome
RPMS += NetworkManager-tui
RPMS += NetworkManager-wifi
RPMS += alsa-sof-firmware
RPMS += ansible
RPMS += bat
RPMS += brightnessctl
RPMS += cscope
RPMS += cups
RPMS += fedora-workstation-repositories
RPMS += file-roller
RPMS += firefox
RPMS += fontawesome-fonts
RPMS += foot
RPMS += fzf
RPMS += gdouros-symbola-fonts
RPMS += git
RPMS += git-email
RPMS += google-chrome-stable
RPMS += grimshot
RPMS += hexchat
RPMS += hplip
RPMS += htop
RPMS += imv
RPMS += inotify-tools
RPMS += iwlax2xx-firmware
RPMS += kanshi
RPMS += libindicator-gtk3
RPMS += lm_sensors
RPMS += mako
RPMS += msmtp
RPMS += neovim
RPMS += network-manager-applet
RPMS += nm-connection-editor
RPMS += openldap-clients
RPMS += opensc
RPMS += pandoc
RPMS += pcsc-tools
RPMS += pinentry-gtk
RPMS += pipewire
RPMS += pipewire-pulseaudio
RPMS += playerctl
RPMS += pulseaudio-utils
RPMS += python3-dnf-plugin-system-upgrade
RPMS += python3-google-api-client
RPMS += python3-html2text
RPMS += python3-i3ipc
RPMS += python3-ipython
RPMS += python3-neovim
RPMS += python3-oauth2client
RPMS += ripgrep
RPMS += scdoc
RPMS += sqlite
RPMS += strace
RPMS += sway
RPMS += swayidle
RPMS += task
RPMS += terminus-fonts
RPMS += terminus-fonts-console
RPMS += terminus-fonts-grub2
RPMS += tmate
RPMS += tmux
RPMS += waybar
RPMS += wev
RPMS += xdg-desktop-portal-wlr
RPMS += yubikey-manager
RPMS += yubikey-personalization-gui
RPMS += zathura
RPMS += zathura-pdf-mupdf

.PHONY: rpm
rpm:
	sudo dnf install $(RPMS)
