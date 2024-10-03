#!/bin/bash
# Author : Caleb Theil 
# Github page : https://github.com/ctheil
#####################################################
# Tested on : Debian (RaspberryPi OS (with desktop))
# Updated version : v1.1 (Updated on October-2024)
#####################################################
# Purpose : Source config files, enable the display via 'xset', set the display resoution, then execute the chrome instance in kiosk mode
# NOTE: This script must be executed by the 'digipi' user due to the ENV and DISPLAY requriements.
# ”su -c '/opt/kiosk/kiosk.sh' digipi"

RES_FILE="/opt/kiosk/db/config.txt"
logfile="/opt/kiosk/db/logs/error.log"
source $RES_FILE

echo "
*** KIOSK ***
$(date)
*************
" >> $logfile

# DISABLE SCREEN BLANKING
xset s off >> $logfile 2>&1
xset -dpms >> $logfile 2>&1
xset s noblank >> $logfile 2>&1

#SET DEFAULT RES
xrandr --output HDMI-1 --mode $default_resolution -r $default_refresh_rate >> $logfile 2>&1

chromium-browser --noerrdialogs --disable-infobars --kiosk https://www.digisign.learning-resources-center.com --disable-translate >> $logfile 2>&1

# Notify
notify-send -u normal -t 60000 "DigiPi Kiosk Started Successfully!

`/opt/kiosk/healthcheck/health-status.sh`
IPv4 & IPv6: `hostname -I`"
