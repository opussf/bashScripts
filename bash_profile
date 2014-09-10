alias gvim='open -a MacVim'
alias hal500='ssh zz9-za.com'
alias ij="/Applications/IntelliJ\ IDEA\ 13\ CE.app/Contents/MacOS/idea > /dev/null 2>&1 &"
alias sub='"/Applications/Sublime Text 2.app/Contents/MacOS/Sublime Text 2" &'

parse_git_branch(){
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
free_mem(){
	free="$(( $(vm_stat | awk '/free/ {gsub(/\./, "", $3); print $3}') * 4096 / 1048576))MB"
	echo -ne "[\033[01;31m${free}\033[00m]"
}
align_right(){
	cols=$(tput cols); rcols=$((${cols}-35)); echo -ne "\033[$(tput lines);${rcols}H"
}

export PS1="\A \h:\w\$(parse_git_branch) \u \$(align_right)\$(free_mem)\n$ "

