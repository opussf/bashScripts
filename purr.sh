#!/bin/bash

###
## purr.sh c3w@juicypop.net
##

function pingTest {
	# http://www.commandlinefu.com/commands/view/12135/
	# c3w revised to wrap into loopIT
	ping -c 1 google.com &> /dev/null || growlnotify -m 'ur wifiz, it has teh sad'
}

function loopIT() {
	SLEEP="${1}"
	shift
	CMD="${@}"
	while [ 1 ]; do { ${@}; sleep ${SLEEP}; }; done
}

viewDiff() {
	TAG=${1}
	BASEFILE=${2}
	CLICKURL=${3}
	CHANGE=$(diff ${BASEFILE}.new ${BASEFILE}.previous |wc -l)
	if [ ${CHANGE} != 0 ]; then {
		( echo ${TAG} && diff ${BASEFILE}.new ${BASEFILE}.previous ) | growlnotify --url "${CLICKURL}"
	}; fi
	cp ${BASEFILE}.new ${BASEFILE}.previous
}

rssViewTag() {
	TAG=${1}
	URL=${2}
	BLOCK=${3}
	CLICKURL=${4}
	BASEFILE=${5}
	curl ${URL} 2>/dev/null|grep "<${BLOCK}>"|sed -e "s/.*\<${BLOCK}\>\(.*\)\<\/${BLOCK}\>.*/\1/g" > ${BASEFILE}.new
	viewDiff ${TAG} ${BASEFILE} ${CLICKURL}
}

#function subscribeCommandFu {
#	BASEFILE="/tmp/purr_commandlinefu"
#	rssViewTag "commandlinefu" "http://www.commandlinefu.com/commands/browse/rss" code ${BASEFILE}
#}


###
## SUBSCRIBE HERE
##
loopIT 10 pingTest&	# checks IP connectivity to google
loopIT 600 rssViewTag "commandlinefu" "http://www.commandlinefu.com/commands/browse/rss" code "http://commandlinefu.com/" /tmp/purr_commandlinefu&
loopIT 600 rssViewTag "macrumors" "http://feeds.macrumors.com/MacRumors-All?format=xml" title "http://macrumors.com/" /tmp/purr_macrumors&
loopIT 600 rssViewTag "FEMA" "http://www.fema.gov/data/disasters.rss" title "http://www.fema.gov/" /tmp/purr_fema&
loopIT 600 rssViewTag "CERT" "http://www.cert.org/nav/cert_announcements.rss" title "http://www.cert.org/" /tmp/purr_cert&
