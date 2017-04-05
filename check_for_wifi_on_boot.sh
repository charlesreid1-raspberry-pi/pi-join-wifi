#!/bin/bash
# 
# http://raspberrypi.stackexchange.com/questions/4120/how-to-automatically-reconnect-wifi
# 

wifi_mod=`lsmod | grep 8192cu`
if [ "$wifi_mod" ]; then
        echo "Starting wifi..."
        /usr/bin/nice -n -10 /usr/local/bin/wifi &
else
        echo "Starting ethernet..."
        /sbin/ifconfig eth0 up
        /sbin/dhclient eth0
fi
# The point of the if is that if my wifi dongle is plugged into the pi, the 8192cu module will be loaded by the kernel at this point -- so wifi should start. If not, then it's assumed that the ethernet is plugged in and should be used (if it is isn't, dhclient will just crap out and there is no network access).