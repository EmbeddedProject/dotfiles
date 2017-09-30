#-------------------------------------------------------------
# Some settings
#-------------------------------------------------------------

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTFILESIZE=4000

# Share the history amongst all terminals
# This tells bash to save the history after *each* command
# default behaviour is to save history on terminal exit
shopt -s histappend histreedit histverify
__prompt_command() {
	# append history lines from this session to the history file
	history -a
	# read all history lines not already read from the history file and
	# append them to the history list
	history -n
	# set terminal title to the current directory
	echo -en "\e]0;bash: ${PWD/#$HOME/\~}\a"
}
export PROMPT_COMMAND='__prompt_command'

export EDITOR="vim"
export PAGER='less'
export LESS='-RS'
export TERM='xterm-256color'
export LC_ALL='en_US.utf-8'
export LANG=$LC_ALL

#--------------#
# shell prompt #
#--------------#
fancy_prompt() {
	local Z="\[\033[0m\]"		# unset all colors

	# regular colors
	local k="\[\033[0;30m\]"	# black
	local r="\[\033[0;31m\]"	# red
	local g="\[\033[0;32m\]"	# green
	local y="\[\033[0;33m\]"	# yellow
	local b="\[\033[0;34m\]"	# blue
	local m="\[\033[0;35m\]"	# magenta
	local c="\[\033[0;36m\]"	# cyan
	local w="\[\033[0;37m\]"	# white

	# emphasized (bolded) colors
	local K="\[\033[1;30m\]"
	local R="\[\033[1;31m\]"
	local G="\[\033[1;32m\]"
	local Y="\[\033[1;33m\]"
	local B="\[\033[1;34m\]"
	local M="\[\033[1;35m\]"
	local C="\[\033[1;36m\]"
	local W="\[\033[1;37m\]"

	if [ `id -u` = 0 ]; then
		# custom color for 'root'
		export PS1="$R\u$Z$r@\h$Z:$c\w$Z$y#$Z "
	else
		if [ "${_GIT_PS1_PROMPT}" != "no" ]; then
			export PS1="$G\u$Z$g@\h$Z:$c\w$Z$m\$(__git_ps1 ' %s')$Z$y\$$Z "
		else
			export PS1="$G\u$Z$g@\h$Z:$c\w$Z$y\$$Z "
		fi
	fi
}
fancy_prompt

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi
