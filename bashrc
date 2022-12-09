#-------------------------------------------------------------
# Some settings
#-------------------------------------------------------------

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTTIMEFORMAT="%a %F %T -- "
export HISTSIZE=65536
export HISTFILESIZE=-1
export HISTIGNORE=ls:ps:history:ll:l:jobs
export HISTCONTROL=ignoreboth:erasedups

# Share the history amongst all terminals
# This tells bash to save the history after *each* command
# default behaviour is to save history on terminal exit
shopt -s histappend histreedit histverify
__prompt_command() {
	history -a
	# set terminal title to the current directory
	echo -en "\e]0;bash: ${PWD/#$HOME/\~}\a"
}
export PROMPT_COMMAND='__prompt_command'

if type -fP nvim &>/dev/null; then
	export EDITOR=nvim
else
	export EDITOR=vim
fi
export PAGER='less'
export LESS='-RS'
export LESSSECURE=1
export CLICOLOR=1
# enable color in man pages: bold is CYAN, underline is GREEN
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_ue=$'\e[0m'
export GROFF_NO_SGR=1
export DEBFULLNAME='Robin Jarry'
export DEBEMAIL='robin@jarry.cc'
export LESSOPEN='|/usr/share/source-highlight/src-hilite-lesspipe.sh "%s"'

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
if [ -r /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
	. /usr/share/git-core/contrib/completion/git-prompt.sh
fi

fancy_prompt() {
	local Z="\[\e[0m\]"		# unset all colors
	local p="\[\e[38;5;197m\]"	# git: pink 197
	local c="\[\e[38;5;47m\]"	# current directory: green 47
	local H='\$'
	local index=$(head -c1 /etc/machine-id)
	local h U color y
	declare -a palette
	declare -A colors
	palette=(33 121 51 159 208 214 226 219 177 165 39 118 40 106 28)
	local i=0 j=0
	for i in {0..9} {a..f}; do
		colors[$i]=${palette[$j]}
		j=$(((j + 1) % ${#palette[@]}))
	done
	#for x in ${!colors[@]}; do
	#	if [ "$x" = "$index" ]; then
	#		active="*"
	#	else
	#		active=" "
	#	fi
	#	printf '%s %s=%s\n' "$active" "$x" "${colors[$x]}"
	#done
	color=${colors[$index]}
	h="\[\e[38;5;${color}m\]"  # hostname
	U="\[\e[1;38;5;${color}m\]"  # username
	if [ `id -u` = 0 ]; then
		y="\[\e[1;38;5;9m\]"  # root prompt char in red
	else
		y="\[\e[38;5;220m\]"  # prompt char: yellow
	fi

	if type -t __git_ps1 >/dev/null; then
		PS1="$U\u$Z$h@\h$Z:$c\w$Z$p\$(__git_ps1 ' %s')$Z$y$H$Z "
	else
		PS1="$U\u$Z$h@\h$Z:$c\w$Z$y$H$Z "
	fi

	export PS1
}
fancy_prompt
unset -f fancy_prompt

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi
