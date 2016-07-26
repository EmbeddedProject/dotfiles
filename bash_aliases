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

alias mkdir='mkdir -p'

alias h='history'
alias j='jobs -l'
alias which='type -a'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

alias du='du -kh'       # Makes a more readable output.
alias df='df -kTh'

alias cls="clear"       # for windows fans
alias v="vim"
alias vi="vim"

alias grep='grep --color=auto'

alias g='git'
alias gg='git grep'

alias ls="ls -hF --group-directories-first --color=auto --time-style=iso"
alias la="ls -A"
alias ll="ls -l"
alias l="ls -l"
alias lla="ls -lA"
alias lm='ll | more'    # pipe through 'more'
alias lg='ll | grep'    # pipe through 'grep'
alias lr='ll -tr'

alias env='env | sort'

alias sshunsafe='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias scpunsafe='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
key=/aston/h_debit/deliveries/delivery/packager/master/ansible/FS/home/rbb/.ssh/robobuild
if [ -f $key ]; then
	alias sshrbb="ssh -i $key -l robobuild"
	alias scprbb="scp -i $key -o User=robobuild"
fi

# fuzzy find (case insensitive)
function ff()
{
	find . | grep -i $1
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
alias man="LESS_TERMCAP_md=$'\e[1;36m' LESS_TERMCAP_me=$'\e[0m' LESS_TERMCAP_us=$'\e[1;32m' LESS_TERMCAP_ue=$'\e[0m' man"
