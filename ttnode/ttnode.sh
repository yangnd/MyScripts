#!/bin/bash

if ! command -v ping >/dev/null 2>&1; then
    apt update
    apt install -y dialog apt-utils libterm-readkey-perl iputils-ping traceroute
fi

while true;do
    if [ ! -n "$(ps fax | grep '/ttnode/ttnode -p' | egrep -v 'grep|echo|rpm|moni|guard')" ]; then
        /ttnode/ttnode -p /ttnode
    fi
    sleep 60
done
