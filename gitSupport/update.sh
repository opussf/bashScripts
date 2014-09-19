#!/bin/bash
#########################################
## This script looks for git repos as subdirectories and fetches remote updates.
## The updates are performed in parallel, with update info being logged,
## and reported on at the end.

gitupdate() {
	echo "Updating: -- ${1} --" >> ../update.${1}.log
	echo "--------" >> ../update.${1}.log
	git remote -v update >> ../update.${1}.log 2>&1
	git pull --ff-only >> ../update.${1}.log 2>&1
	echo "========" >> ../update.${1}.log
}

echo "=========="
for repo in `ls`
do
if [ -d $repo ]; then
pushd $repo >> /dev/null
if [ -d ".git" ]; then
	echo "(git) ${repo}"
	gitupdate $repo &
fi
popd >> /dev/null
fi
done
echo "--- Waiting for updates to happen ---"
wait
echo "=========="
rm update.log
for repo in `ls`
do
if [ -f update.${repo}.log ]; then
	cat update.${repo}.log >> update.log
	rm update.${repo}.log
fi
done
cat update.log
