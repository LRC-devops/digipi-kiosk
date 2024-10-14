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


# Turn the TV on
/opt/kiosk/cec-controls on
notify-send -u normal -t 60000 "DigiPi Starting" "TV Turned on successfully. Setting resolution now"
sleep 60

# DISABLE SCREEN BLANKING
xset s off >> $logfile 2>&1
xset -dpms >> $logfile 2>&1
xset s noblank >> $logfile 2>&1

#SET DEFAULT RES
xrandr --output HDMI-1 --mode $default_resolution -r $default_refresh_rate >> $logfile 2>&1
# Set the maximum number of attempts
max_attempts=5

# Set a counter for the number of attempts
attempt_num=1

# Set a flag to indicate whether the command was successful
success=false

# Loop until the command is successful or the maximum number of attempts is reached
while [ $success = false ] && [ $attempt_num -le $max_attempts ]; do

  # Execute the command
  echo "ATTEMPT: $attempt_num" >> $logfile
xrandr --output "HDMI-1" --mode 1920x1080 -r 60 >> $logfile 2>&1


  # Check the exit code of the command
  if [ $? -eq 0 ]; then
    # The command was successful
notify-send -u normal -t 60000 "DigiPi Starting" "Successfully set the resolution."
    success=true
  else
    # The command was not successful
    echo "Attempt $attempt_num failed. Trying again..."
notify-send -u normal -t 60000 "DigiPi Starting" "Failed to set the resolution. Trying again..."
    # Increment the attempt counter
    attempt_num=$(( attempt_num + 1 ))
  fi
done

# Check if the command was successful
if [ $success = true ]; then
  # The command was successful
  echo "The command was successful after $attempt_num attempts." >> $logfile
else
  # The command was not successful
  echo "The command failed after $max_attempts attempts." >> $logfile
fi

chromium-browser --noerrdialogs --disable-infobars --kiosk https://www.digisign.learning-resources-center.com --disable-translate >> $logfile 2>&1

# Notify
notify-send -u normal -t 60000 "DigiPi Kiosk Started Successfully!

`/opt/kiosk/healthcheck/health-status.sh`
IPv4 & IPv6: `hostname -I`"
notify-send -u normal -t 60000 "DigiPi Kiosk Started Successfully!

`/opt/kiosk/healthcheck/health-status.sh`
IPv4 & IPv6: `hostname -I`"
