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
alias which='type -a'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

alias du='du -kh'       # Makes a more readable output.
alias df='df -kTh'

alias v="vim"
alias vi="vim"
alias e="emacs -nw"

alias grep='grep --color=auto'

alias g='git'
alias gg='git grep'

if dircolors &>/dev/null; then
	eval `dircolors`
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

function env() {
	if [ $# -eq 0 ]; then
		command env | sort
	else
		command env "$@"
	fi
}

tracker=/aston/h_debit/deliveries/infrastructure/tracker
if [ -f $tracker/extras/bash_completion.d/trk ]; then
	. $tracker/extras/bash_completion.d/trk
fi
unset tracker

alias sshunsafe='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias scpunsafe='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
key=/aston/h_debit/deliveries/delivery/packager/master/ansible/FS/home/rbb/.ssh/robobuild
if [ -f $key ]; then
	alias sshrbb="ssh -i $key -l robobuild"
	alias scprbb="scp -i $key -o User=robobuild"
fi

# fuzzy find (case insensitive)
function ff() {
	local pattern="$1"
	shift
	if [ $# -eq 0 ]; then
		set -- .
	fi
	find "$@" | grep -i -- "$pattern"
}

if type colordiff >/dev/null 2>&1; then
	alias diff='colordiff -Naup'
else
	alias diff='diff -Naup'
fi
if type pinfo >/dev/null 2>&1; then
	alias info=pinfo
fi

alias makedoc='make -f ~/devel/doc-tools/doc-tools.mk'

# enable color in man pages: bold is CYAN, underline is GREEN
function man() {
	LESS_TERMCAP_md=$'\e[1;36m' \
	LESS_TERMCAP_me=$'\e[0m' \
	LESS_TERMCAP_us=$'\e[1;32m' \
	LESS_TERMCAP_ue=$'\e[0m' \
	command man "$@"
}

alias ncal='ncal -Mw3'

function termcolors() {
	for i in {0..255}; do
		printf "%3d \e[48;5;%sm   \e[0m " "$i" "$i"
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

_completion_loader pass
alias pass-it='PASSWORD_STORE_DIR=~/.passwords-it pass'
complete -o filenames -F _pass pass-it
