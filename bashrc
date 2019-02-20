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
	# set terminal title to the current directory
	echo -en "\e]0;bash: ${PWD/#$HOME/\~}\a"
}
export PROMPT_COMMAND='__prompt_command'

export EDITOR="vim"
export PAGER='less'
export LESS='-RS'
export DEBFULLNAME='Robin Jarry'
export DEBEMAIL='robin@jarry.cc'
export LESSOPEN='|/usr/share/source-highlight/src-hilite-lesspipe.sh "%s"'
: ${LC_ALL:=en_US.utf-8}
: ${LANG:=$LC_ALL}
: ${XDG_CONFIG_HOME:=$HOME/.config}
export LC_ALL LANG XDG_CONFIG_HOME
unset SSH_AGENT_PID
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export GPG_TTY=$(tty)

if shopt -q progcomp && [ -z "$BASH_COMPLETION_COMPAT_DIR" ]; then
	if [ -r /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -r /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

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
		PS1="$R\u$Z$r@\h$Z:$c\w$Z$y\$$Z "
	else
		if type -t __git_ps1 >/dev/null; then
			PS1="$G\u$Z$g@\h$Z:$c\w$Z$p\$(__git_ps1 ' %s')$Z$y\$$Z "
		else
			PS1="$G\u$Z$g@\h$Z:$c\w$Z$y\$$Z "
		fi
	fi

	export PS1
}
fancy_prompt
unset -f fancy_prompt

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi
