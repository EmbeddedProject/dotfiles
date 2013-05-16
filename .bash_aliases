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

alias ls="ls -hF --group-directories-first --color=auto --time-style=iso"
alias la="ls -A"
alias ll="ls -l"
alias lla="ls -lA"
alias lx='ls -lAXB'         # sort by extension
alias lk='ls -lASr'         # sort by size, biggest last
alias lc='ls -lAtcr'        # sort by and show change time, most recent last
alias lu='ls -lAtur'        # sort by and show access time, most recent last
alias lt='ls -lAtr'         # sort by date, most recent last
alias lm='ll | more'    # pipe through 'more'
alias lg='ll | grep'    # pipe through 'grep'
alias lr='ll -tr'

alias gshow='git show'
alias gsh='gshow'
alias gstatus='git status'
alias gstat='gstatus'
alias gst='gstatus'
alias gcommit='git ci'
alias gci='gcommit'
alias grebase='git rebase'
alias gre='grebase'
alias gcheckout='git checkout'
alias gco='gcheckout'
alias gclean='git clean'
alias gcherry='git chpick'
alias gch='gcherry'
alias gg='git grep'
alias gdiff='git diff'
alias gdf='gdiff'

# fuzzy find (case insensitive)
function ff()
{
	    find . | grep -i $1
}

alias diff='colordiff -Naup'
alias less='less -R'

alias component='LOG=`/aston/h_debit/deliveries/infrastructure/admin-tools/build_components_log.sh ; echo -e "Acked-by: Emmanuel Vize <emmanuel.vize@6wind.com>"` ; git commit -s -m "$LOG" -e components.config'
