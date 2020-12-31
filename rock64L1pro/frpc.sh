#!/bin/bash

time=`date +%F_%H%M%S`
echo "check time: $time"
psfrpc=`ps -ef | grep frpc | egrep -v 'grep|frpc.sh'`
echo $psfrpc
if [ -z "$psfrpc" ]
then
	echo "frpc stop"
	echo "start frpc"
	/etc/init.d/frp start
else
	echo "frpc running"
fi
exit 0
