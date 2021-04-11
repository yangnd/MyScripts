#!/bin/bash

__ipes_uninstall() {
    _more_length=$(cat /etc/systemd/system/ipesdaemon.service | grep ExecStart | awk '{print length($0)-17}')
    _app=$(cat /etc/systemd/system/ipesdaemon.service | grep ExecStart | cut -c 24-$_more_length)
    crontab -r
    $_app/bin/ipes uninstall
    $_app/bin/ipes stop
    pkill ipes
    pkill happ
    rm -rf $_app
}
__ipes_uninstall