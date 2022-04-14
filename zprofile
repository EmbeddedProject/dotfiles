# vim: ft=zsh

PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/go/bin:$PATH"
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"

agent_sock=$(gpgconf --list-dirs agent-socket)
export GPG_AGENT_INFO=${agent_sock}:0:1
if [ -n "$(gpgconf --list-options gpg-agent | \
	awk -F: '/^enable-ssh-support:/{ print $10 }')" ]; then
	export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

if [ "$(tty)" = "/dev/tty1" ]; then
	export XDG_CURRENT_DESKTOP=sway
	exec systemd-cat --identifier=sway sway
fi
