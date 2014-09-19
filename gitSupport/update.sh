#!/bin/bash

gitupdate() {
	echo "========" > update.log
	echo "Updating ${1}" >> update.log
	echo "--------" >> update.log
	git remote -v update >> update.log 2>&1
	git pull --ff-only >> update.log 2>&1
	echo "========" >> update.log
}

for repo in `ls`
do
if [ -d $repo ]; then
echo "=========="
echo "    ${repo}"
pushd $repo >> /dev/null
if [ -d ".git" ]; then
	gitupdate $repo &
fi
popd >> /dev/null
fi
done
wait
echo "=========="
rm update.log
for repo in `ls`
do
if [ -f ${repo}/update.log ]; then
	cat ${repo}/update.log >> update.log
fi
done
cat update.log
