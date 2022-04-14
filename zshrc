# vim: ft=zsh

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=10000
setopt NOTIFY LIST_PACKED
unsetopt AUTOCD BEEP EXTENDEDGLOB
WORDCHARS="*?_-.[]~&;$%^+"

# bindings
bindkey -e  # emacs mode
bindkey "^[[A" history-beginning-search-backward  # up
bindkey "^[[B" history-beginning-search-forward  # down
bindkey "^[[1;5C" forward-word  # ctrl-right
bindkey "^[[1;5D" backward-word  # ctrl-left
bindkey "^[[3;5~" kill-word  # ctrl-delete
bindkey "^[[H" beginning-of-line  # home
bindkey "^[[F" end-of-line  # end
bindkey "^[[3~" delete-char  # delete
bindkey "^[[Z" reverse-menu-complete  # shift-tab

# completion
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose false
eval $(TERM=xterm-256color dircolors)
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS} "ma=48;5;25;1"
zstyle ':completion:*:git:*' tag-order - '! plumbing-sync-commands plumbing-sync-helper-commands plumbing-internal-helper-commands plumbing-manipulator-commands'
zstyle ':completion:*:complete:git:argument-1:*' ignored-patterns restore
autoload -Uz compinit
compinit

# variables
export EDITOR=nvim
export PAGER=less
export LESS=-RS
export TERMCOLOR=truecolor
export CLICOLOR=1
export DEBFULLNAME='Robin Jarry'
export DEBEMAIL='robin@jarry.cc'
export LESSOPEN='|/usr/bin/src-hilite-lesspipe.sh "%s"'

# prompt
function term_title() {
	tput tsl
	print -D "zsh:" "$PWD"
	tput fsl
}
autoload -Uz vcs_info
precmd_functions+=( vcs_info term_title )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats ' %F{197}%b%f'
zstyle ':vcs_info:*' enable git
PROMPT='%B%F{39}%n%b@%m%f'  # *user*@host (blue 39)
PROMPT+=':'
PROMPT+='%F{47}%~%f'  # current dir (green 47)
PROMPT+='${vcs_info_msg_0_}'  # git info (pink 197)
PROMPT+='%F{220}\$%f ' # dollar (yellow 220)

# aliases
unalias -a
alias mkdir='mkdir -p'
alias path='echo -e ${PATH//:/\\n}'
alias du='du -kh'
alias df='df -kTh'
alias vim="nvim"
alias v="nvim"
alias vi="nvim"
alias e="emacs -nw"
alias imv=imv-wayland
alias grep='grep --color'
alias gg='git grep'
alias ls="ls -hF --time-style=iso --color"
alias la="ls -A"
alias ll="ls -l"
alias l="ls -l"
alias lla="ls -lA"
alias pg='pgrep -a'
alias sshunsafe='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias scpunsafe='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias diff='diff -Naup --color'
alias ncal='ncal -Mw3'

# enable color in man pages: bold is CYAN, underline is GREEN
function man() {
	LESS_TERMCAP_md=$'\e[1;36m' \
	LESS_TERMCAP_me=$'\e[0m' \
	LESS_TERMCAP_us=$'\e[1;32m' \
	LESS_TERMCAP_ue=$'\e[0m' \
	GROFF_NO_SGR=1 \
	command man "$@"
}

function env() {
	if [ $# -eq 0 ]; then
		command env | sort
	else
		command env "$@"
	fi
}

# fuzzy find (case insensitive)
function ff() {
	local pattern="$1"
	shift
	if [ $# -eq 0 ]; then
		set -- .
	fi
	find "$@" | grep -i -- "$pattern"
}

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

function termcolors() {
	for i in {0..255}; do
		printf "\e[38;5;%sm%3d\e[0m \e[48;5;%sm%3d\e[0m " "$i" "$i" "$i" "$i"
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
