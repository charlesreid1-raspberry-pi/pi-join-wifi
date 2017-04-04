#!/bin/bash
#
# via http://raspberrypi.stackexchange.com/questions/4120/how-to-automatically-reconnect-wifi
#
# contents of /etc/wifi.conf:
#
# router_ip=192.168.0.1
# log=/var/log/wifi.log
# wlan=wlan0
# eth=eth0
# essid=someNetwork
# check_interval=5
#

# make sure we aren't running already
what=`basename $0`
for p in `ps h -o pid -C $what`; do
        if [ $p != $$ ]; then
                exit 0
        fi
done

# source configuration
. /etc/wifi.conf

exec 1> /dev/null
exec 2>> $log
echo $(date) > $log
# without check_interval set, we risk a 0 sleep = busy loop
if [ ! "$check_interval" ]; then
        echo "No check interval set!" >> $log
        exit 1
fi

startWifi () {
        dhclient -v -r
    # make really sure
        killall dhclient
        iwconfig $wlan essid $essid
        dhclient -v $wlan
}

ifconfig $eth down
ifconfig $wlan up
startWifi

while [ 1 ]; do
        ping -c 1 $router_ip & wait $!
        if [ $? != 0 ]; then
                echo $(date)" attempting restart..." >> $log
                startWifi
                sleep 1
        else sleep $check_interval
        fi
done
