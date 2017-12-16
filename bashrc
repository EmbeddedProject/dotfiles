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
export LC_ALL='en_US.utf-8'
export LANG=$LC_ALL

#--------------#
# shell prompt #
#--------------#
fancy_prompt() {
	local Z="\[\e[0m\]"		# unset all colors

	local y="\[\e[38;5;220m\]"	# prompt char: yellow 220
	local R="\[\e[1;38;5;196m\]"	# root username: bold red 196
	local r="\[\e[38;5;160m\]"	# root host: red 160
	local G="\[\e[1;38;5;39m\]"	# username: bold blue 39
	local g="\[\e[38;5;39m\]"	# host: blue 39
	local p="\[\e[38;5;197m\]"	# git: pink 197
	local c="\[\e[38;5;47m\]"	# current directory: green 47

	if [ `id -u` = 0 ]; then
		# custom color for 'root'
		export PS1="$R\u$Z$r@\h$Z:$c\w$Z$y\$$Z "
	else
		export PS1="$G\u$Z$g@\h$Z:$c\w$Z$p\$(__git_ps1 ' %s')$Z$y\$$Z "
	fi
}
fancy_prompt
unset -f fancy_prompt

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi
