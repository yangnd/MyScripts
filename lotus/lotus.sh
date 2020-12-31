#!/bin/bash
time=`date +%F_%T`
echo $time >> ~/lotus.log
if [ -z "`ps -ef | grep 'lotus daemon' | egrep -v grep`" ]
then
	echo "lotus crash" >> ~/lotus.log
	if [ -z "`command -v lotus`" ]
	then
		echo "lotus is not installed" >> ~/lotus.log
	else
		echo "lotus start" >> ~/lotus.log
		nohup lotus daemon &
	fi
else
	echo "lotus running" >> ~/lotus.log
fi

# del old log
while [ "`cat ~/lotus.log | wc -l`" -gt 1000 ]
do
#	echo "del 1st line"
	sed -i '1d' ~/lotus.log
done
echo "done"

exit 0
