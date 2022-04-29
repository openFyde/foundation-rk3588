#!/bin/sh
sleep 1
/bin/ifconfig wlan0 up
echo 1 > /sys/class/rfkill/rfkill0/state
sleep 1
start brcm_bt_patchrom
