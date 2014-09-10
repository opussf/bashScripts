alias gvim='open -a MacVim'
alias hal500='ssh zz9-za.com'
alias ij="/Applications/IntelliJ\ IDEA\ 13\ CE.app/Contents/MacOS/idea > /dev/null 2>&1 &"
alias sub='"/Applications/Sublime Text 2.app/Contents/MacOS/Sublime Text 2" &'

#-----  Prompt code
#  https://wiki.archlinux.org/index.php/Color_Bash_Prompt
#-----
parse_git_branch(){
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
align_right(){
	cols=$(tput cols); rcols=$((${cols}-35)); echo -ne "\033[$(tput lines);${rcols}H"
}
mach_factor(){
	mf="$(hostinfo|grep "Mach factor"|cut -d: -f2| cut -d, -f1|awk '{print $1}') mf"
	echo -ne "[\033[0;36m${mf}\033[00m]"
}
free_mem(){
	free="$(( $(vm_stat | awk '/free/ {gsub(/\./, "", $3); print $3}') * 4096 / 1048576)) MB"
	echo -ne "[\033[00;31m${free}\033[00m]"
}

export PS1="\A (\!) \h:\w\$(parse_git_branch) \$(align_right)\$(mach_factor)\$(free_mem)\n$ "

#----
# http://gohgarry.wordpress.com/2010/01/16/fun-with-mac-say-command/
#----

rssViewDiff(){
	TAG=${1}
	BASEFILE=${2}
	CLICKURL=${3}
	CHANGE=$(diff ${BASEFILE}.new ${BASEFILE}.previous | wc -l)
	if [ ${CHANGE} -ne 0 ]; then {
		( echo ${TAG} && diff ${BASEFILE}.new ${BASEFILE}.previous ) | terminal-notifier -open ${CLICKURL} -message
	}; fi
	( diff ${BASEFILE}.new ${BASEFILE}.previous ) | say
	mv ${BASEFILE}.new ${BASEFILE}.previous
}

rssViewTag(){
	TAG=${1}
	URL=${2}
	BLOCK=${3}
	CLICKURL=${4}
	BASEFILE=${5}
	curl ${URL} 2>/dev/null | grep "<${BLOCK}>" | sed -e "s/.*\<${BLOCK}.*\>\(.*\)\<\/${BLOCK}\>.*/\1/g" > ${BASEFILE}.new
	rssViewDiff "${TAG}" ${BASEFILE} ${CLICKURL}
}
