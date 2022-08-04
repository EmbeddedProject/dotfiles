#!/bin/bash

# switch between root and normal user with the command 'op'
# 'op' stands for 'operator'
function op()
{
	if [ "`id -u`" = 0 ]; then
		exit
	else
		sudo su -
	fi
}

unalias -a

alias mkdir='mkdir -p'

alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

alias du='du -kh'       # Makes a more readable output.
alias df='df -kTh'

alias vim="$EDITOR"
alias v="$EDITOR"
alias vi="$EDITOR"
alias e="emacs -nw"
alias imv=imv-wayland

if [ "$(type -t _completion_loader 2>/dev/null)" = function ]; then
	_completion_loader task
	alias t=task
	complete -F _task t
fi

alias grep='grep --color=auto'
alias gg='git grep --untracked'

if dircolors &>/dev/null; then
	eval $(dircolors ~/.dir_colors)
elif uname -s | grep -qE 'Darwin|FreeBSD'; then
	export CLICOLOR=1
	export LSCOLORS=ExgxfxdxCxegedabagacad
fi
lsopt="-hF"
if command ls --time-style=iso &>/dev/null; then
	lsopt="$lsopt --time-style=iso"
fi
if command ls --color=auto &>/dev/null; then
	lsopt="$lsopt --color=auto"
fi
alias ls="ls $lsopt"
unset lsopt
alias la="ls -A"
alias ll="ls -l"
alias l="ls -l"
alias lla="ls -lA"

alias pg='pgrep -a'

alias ldapsearch='ldapsearch -Q -o ldif-wrap=no -LLL'

function env() {
	if [ $# -eq 0 ]; then
		command env | sort
	else
		command env "$@"
	fi
}

alias sshunsafe='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias scpunsafe='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

# fuzzy find (case insensitive)
function ff() {
	local pattern="$1"
	shift
	if [ $# -eq 0 ]; then
		set -- .
	fi
	find "$@" | grep -i -- "$pattern"
}

alias diff='diff -up'

if type pinfo >/dev/null 2>&1; then
	alias info=pinfo
fi

# enable color in man pages: bold is CYAN, underline is GREEN
function man() {
	LESS_TERMCAP_md=$'\e[1;36m' \
	LESS_TERMCAP_me=$'\e[0m' \
	LESS_TERMCAP_us=$'\e[1;32m' \
	LESS_TERMCAP_ue=$'\e[0m' \
	GROFF_NO_SGR=1 \
	command man "$@"
}

alias ncal='ncal -Mw3'

function termcolors() {
	for i in {0..255}; do
		printf "\e[38;5;%sm%3d\e[0m \e[1;38;5;%sm%3d\e[0m \e[48;5;%sm%3d\e[0m " \
			"$i" "$i" "$i" "$i" "$i" "$i"
		if (( i == 7 )) || (( i == 15 )); then
			printf '\n'
		elif (( i > 15 )) && (( (i-15) % 6 == 0 )); then
			printf '\n'
		fi
	done
}

function gpg_update_tty() {
	gpg-connect-agent updatestartuptty /bye
}

function resetcard() {
	rm -rf ~/.gnupg/private-keys-v1.d
	gpgconf --kill gpg-agent
	gpg --card-status
}
