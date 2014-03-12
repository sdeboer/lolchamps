# If not running interactively, don't do anything
case $- in
	*i*) ;;
*) return;;
esac

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

export GPG_TTY=‘tty‘

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	elif [ -f /usr/local/etc/bash_completion ]; then
		. /usr/local/etc/bash_completion
	fi
fi

if [[ -e ${HOME}/.gitutil ]]; then
	export GIT_PS1_SHOWDIRTYSTATE=1
	source ${HOME}/.gitutil/git-prompt.sh
	source ${HOME}/.gitutil/git-completion.bash
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='\W$(__git_ps1 " [%s]")\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
else
	alias ls='ls -G'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias p='ls -FAC'
# included here because it is an extension the ls aliases
function lt {
ls -AlFt $* |head
}
alias tf='tail -50'

alias r='fc -s'
alias h='fc -l'

alias pd=pushd

alias eperl='eperl -B "<?" -E "!>" -mc'
alias g='egrep -i'
alias hls="find . -maxdepth 1 -type f -and -name '.??*' -print"
alias j=jobs

alias tls='tmux ls'
alias ta='tmux attach'

function z {
local dir="${HOME}/work/${1}"
if [[ ! -d $dir ]]; then
  dir=$1
fi

if [[ ! -d $dir ]]; then
  echo "Cannot find ${1} to go to!" 1>&2
  return 1
fi

echo $dir

cd $dir
if [[ ! "$TMUX" = "" ]]; then
  name=$(basename $dir)
  tmux rename-window $name
fi
}

# old mh aliases
alias cl='comp -form ~/Mail/logbookcomp'
alias compp='comp -form ~/Mail/psi/components'
alias comps='comp -form ~/Mail/sdeboer/components'
alias cweb='comp -form ~/Mail/webmastercomp'
alias fl='folder'
alias fls='folders'
alias forwp='forw -form ~/Mail/psi/forwcomps'
alias forws='forw -form ~/Mail/sdeboer/forwcomps'
alias rall='repl -cc to -cc cc -nocc me'
alias rallp='repl -form ~/Mail/psi/replcomps -cc to -cc cc -nocc me'
alias ralls='repl -form ~/Mail/sdeboer/replcomps -cc to -cc cc -nocc me'
alias replp='repl -form ~/Mail/psi/replcomps'
alias repls='repl -form ~/Mail/sdeboer/replcomps'
alias rfw='refile cur +work'
alias s10='scan -header last:10'
alias s='scan -header'
alias sc10='scan -header last:10'
alias sc='scan -header'
alias seen='mark -delete -seq unseen'
alias unseen='mark -add -seq unseen'

#       biff y

function sui {
if [ "X$1" = "X" ]; then
	show unseen +in
else
	show unseen $1
fi
}

function pcode {
expand -3 <$1 | filep -s "$1"
}

function pmp {
local MODE
if [ "X$1" = "X-l" ]; then
	shift;
	MODE="-landscape"
fi
if [ "X$1" = "X" ]; then
	mailp $MODE `mhpath cur` >/dev/null
else
	mailp $MODE `mhpath $1` >/dev/null
fi
}

function psrc {
if [ "X$1" = "X" ]; then
	less `mhpath cur`
else
	less `mhpath $1`
fi
}

function seqs {
cat `mhpath $1`/.mh_sequences
}

function scu {
#$HOME/.mail/getmail
for i in +in +todo +personal +logbook +in/web +in/slashcode $1
do
	if
		(test -e `/usr/bin/mhpath $i`/.mh_sequences \
			&& grep -q '^unseen' `/usr/bin/mhpath $i`/.mh_sequences \
			&& exit 0)
	then
		folder -push "$i" >/dev/null
		echo "Folder $i"
		scan unseen "$i"
		folder -pop >/dev/null
	fi
done
if
	( test -e `/usr/bin/mhpath +drafts`/.mh_sequences \
		&& grep -q '^cur' `/usr/bin/mhpath +drafts`/.mh_sequences \
		&& exit 0 )
then
	folder -push +drafts >/dev/null
	echo "Folder +drafts"
	scan +drafts
	folder -pop >/dev/null
fi
}

function msc {
if [ "X$1" = "X" ]; then
	FLS="+in +psi +sdeboer"
else
	FLS=$*
fi

for i in $FLS
do
	scan last:10 -header $i 2>&1 | grep -v 'no messages in'
done
}

function scd {
PAT=$1
REP=$2

CUR=`pwd`
NEW=`echo $CUR | sed "s#$1#$2#"`
cd $NEW
}

# User specific aliases and functions
export APP_HOME=${HOME}/FireCat
export KEY_DIR=${HOME}/.ssh
alias cf="cd ${APP_HOME}"

# General setting
export LESS=-R
export RI="-f ansi"
export EDITOR=vi
export PAGER=less

set -o vi
shopt -s cdable_vars cdspell checkhash histappend histreedit histverify checkwinsize

# User specific environment and startup programs

alias aoeu="setxkbmap us -option ctrl:nocaps"
alias ar.g="setxkbmap us -option ctrl:nocaps"
alias asdf="setxkbmap dvorak -option ctrl:nocaps"

alias vib='vi ~/.bashrc'
alias vic='vi ~/.ssh/config'
alias b.='. ~/.bashrc'
alias nocaps='setxkbmap -option ctrl:nocaps'
alias auto='nice -7 xterm -e script/autospec &'
alias c='ssh'
# alias irc='bitchx -c\#gwmm sdeboer chat.us.freenode.net'
alias be='bundle exec'

if [[ "$(uname -s)" = "Darwin" ]]; then
	alias vim="reattach-to-user-namespace mvim"
	export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
	export ECLIPSE_HOME=/Applications/Eclipse
	export RESIN_HOME=/Users/simon/Work/resin-4.0.34
	export PG_HOME=/Library/PostgreSQL/9.2
	export PGUSER=postgres
	export PGHOST=localhost
	export PGPORT=5432
	export MAVEN_OPTS='-Xmx1024m -XX:MaxPermSize=1024m -Xms1024m'

	alias resin=${RESIN_HOME}/bin/resin.sh
	alias ecstop='${ECLIPSE_HOME}/eclim -command shutdown'

	function review {
		local remote
	  remote=$1
		if [[ "$remote" = "" ]]; then
			remote=$(git symbolic-ref -q HEAD)
			remote=${remote##refs/heads/}
		fi
		git push origin HEAD:refs/for/$remote
	}

	function pen {

	local ecpath
	local properties

	case "$1" in
		"w" )
			ls -l ${RESIN_HOME}/conf/resin.properties*
			;;

		"ehr" )
			ecpath=".workspaces/ehr"
			properties="resin.properties.pcehr_v3"
			;;

		"v4" )
			ecpath=".workspaces/v4"
			properties="resin.properties.v4"
			;;

		"stop" )
			echo "Shut down"
			${ECLIPSE_HOME}/eclim -command shutdown
			resin stop
			;;

		* )
			echo "Unrecognized option $1";;
	esac

	if [[ ! -z "$ecpath" ]]; then
		${ECLIPSE_HOME}/eclim -command shutdown
		resin stop
		ln -sf ${RESIN_HOME}/conf/${properties} ${RESIN_HOME}/conf/resin.properties

		${ECLIPSE_HOME}/eclimd -Dosgi.instance.area.default=@user.home/${ecpath} &
		resin start
	fi
}
fi

function d() {
if [[ $# != 0 ]]; then
	pushd $1
else
	popd
fi
}

# RSpec/Cucumber helpers
#alias rsstart="export RUNNING_SPEC_SERVER=1 && nice -7 rake spec:server:start && unset RUNNING_SPEC_SERVER"
#alias rsstop="rake spec:server:stop && rm tmp/pids/spec_server.pid"
#alias cuke="cucumber --drb -q -r features"

#function specs() {
#dir=$1
#last=$(basename $dir)
#
#script/spec $dir -X -fs --loadby mtime >public/specLogs/$last.txt
#}
#function spec() {
#  dir=$1
#  last=`basename $dir`
#
#  script/spec $dir -X -fh --loadby mtime >public/specLogs/$last.html
#}

# GIT BRANCH DIFF SINCE BRANCH
# git d $(git merge-base v4 v4lk)..v4lk

export CHAMP_NAME=Pieslave.properties
export 'CHAMP=/cygdrive/c/Riot Games/League of Legends/RADS/projects/lol_air_client/releases/0.0.1.75/deploy/preferences/${CHAMP_NAME}'

alias cup='cp ${HOME}/${CHAMP_NAME} "${CHAMP}"'
alias cba='cp "$CHAMP" ${HOME}/${CHAMP_NAME}'


if [[ -e ${HOME}/.bashrc.local ]]; then
  source ${HOME}/.bashrc.local
fi

export PATH=./bin:./script:~/bin:${PG_HOME}/bin:/usr/local/sbin:${PATH}:${EC2_HOME}/bin

export RVM="${HOME}/.rvm"
[[ -s ${RVM}/scripts/rvm ]] && source ${RVM}/scripts/rvm && export PATH=${RVM}/bin:${PATH}
