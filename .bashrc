#-------------------------------------------------------------
# Some settings
#-------------------------------------------------------------

ulimit -S -c 0          # Don't want any coredumps.
set -o notify
set -o noclobber
set -o ignoreeof	# disable Ctrl+D
set +o nounset

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize	# change line wrapping on terminal resize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s extglob        # Necessary for programmable completion.
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Disable options:
shopt -u mailwarn
unset MAILCHECK         # Dont want my shell to warn me of incoming mail.

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTFILESIZE=4000
export HISTTIMEFORMAT="%F %T > "
export HISTIGNORE="&:bg:fg:ll:h:ls:exit"
# Share the history amongst all terminals
# This tells bash to save the history after *each* command
# default behaviour is to save history on terminal exit
shopt -s histappend histreedit histverify
export PROMPT_COMMAND='history -a'	# write history after each command

export EDITOR="vim"
export PAGER='less'

export CDPATH=.:~/devel
export PATH=${PATH}:/aston/h_debit/deliveries/delivery/packager/master/utils/
export PATH=${PATH}:/aston/h_debit/deliveries/infrastructure/git-tools/scripts/

#--------------#
# shell prompt #
#--------------#
fancy_prompt() {
	local NONE="\[\033[0m\]"	# unsets color to term's fg color

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
		export PS1="$R\u$NONE@$r\h$NONE:$c\w$NONE\n$y#$NONE "
	else
		export PS1="$G\u$NONE@$g\h$NONE:$c\w$NONE$m\$(__git_ps1 ' %s')$NONE\n$y\$$NONE "
	fi
}
fancy_prompt


if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

