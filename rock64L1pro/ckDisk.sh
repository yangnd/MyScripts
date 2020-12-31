#!/bin/sh
time=`date +%F_%T`
if [ -z "`fdisk -l | grep '/dev/sda'`" ]
then
	echo "$time : disk sda lost"
fi
exit 0
