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
alias apt='aptitude'

alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

alias du='du -kh'       # Makes a more readable output.
alias df='df -kTh'

alias cls="clear"       # for windows fans
alias v="vim"
alias vi="vim"

alias grep='grep --color=auto'
alias g='grep'

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

# fuzzy find (case insensitive)
function ff()
{
	find . | grep -i $1
}

alias diff='colordiff -Naup'
alias less='less -R'
