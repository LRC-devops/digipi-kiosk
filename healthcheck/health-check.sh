
#!/bin/bash
# Author : Caleb Theil
# Adapted from: Tushar Jadhav
# Purpose : To quickly check and report health status in a linux systems
# Tested on : RHEL7/6, Ubuntu14/18, Centos7 variants, Debian (Raspberry piOS)
# Updated version : v1.1 (Updated on October-2024)
# NOTE: This script requires root privileges, otherwise you could run the script
# as a sudo user who got root privileges
# ”sudo /bin/bash <ScriptName>”

D=`date +%m-%d_%H`
Report=/opt/healthcheck/reports/Digipi_Health.$D
echo "Health Report: $D"

echo "############################################
Health Check Report (CPU,Process,Disk Usage, Memory)
############################################
Hostname : $(hostname)
Kernel Version : $(uname -mrs)
Uptime : $(uptime | awk '{gsub (",","");print $3}')
Last Reboot Time : $(who -b | awk '{print $3,$4}')
Load Average : $(uptime | awk -F'[:, ]+' '{print $NF}')
CPU Usage : $(top -bn2 -d1 | awk '/^top/{i++}i==2' | awk 'NR==3 {gsub ("%","");print 100-$8"%"}')
IO Wait : $(top -bn2 -d1 | awk '/^top/{i++}i==2' | awk 'NR==3 {gsub ("%","");print $9"%"}')" > $Report

echo "" >> $Report
echo "*****************************************************************
Health Status
******************************************************************" >> $Report

ncpu=$(grep "model name" /proc/cpuinfo | wc -l)
echo "Number of cpu : $ncpu" >> $Report
echo "Health Status : $(uptime | awk -F'[:, ]+' '{print $NF}' | awk '{if ($1>('$ncpu'+1)) print "Unhealthy";else print "Normal"}')" >> $Report

echo "" >> $Report
echo "******************************************************************
Process
*******************************************************************
=> Top CPU using process/application
$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head)
---------------------------------------------------------------------
=> Top memory using process/application
$(ps -A --sort -rss -o pid,comm,pmem | head | column -t)" >> $Report

echo "" >> $Report
echo "*****************************************************************
Disk Usage && Disk Status
******************************************************************" >> $Report
echo "$(df -h | egrep -iv 'tmpfs|filesystem|none|udev' | awk '{print $1,$6,$4" free",$3" used"} {gsub ("%",""); if ($5>95) print "Unhealthy"; else if ($5>90) print "Caution"; else print "Normal"}' | sed 'N;s/\n/ /' | column -t)" >> $Report

echo "" >> $Report
df -h >> $Report

echo "" >> $Report
echo "****************************************************************
Memory
*****************************************************************
=> Physical Memory" >> $Report

totmem=$(free -m | awk 'NR==2 {printf "%.2f\n", $2/1024}')
usemem=$(free -m | awk 'NR==3 {printf "%.2f\n", $3/1024}')
freemem=$(free -m | awk 'NR==3 {printf "%.2f\n", $4/1024}')
freeper=$(echo "$freemem * 100 / $totmem" | bc)
echo -e "Total\tUsed\tFree\t%Free
${totmem}GB\t${usemem}GB\t${freemem}GB\t${freeper}%" >> $Report

echo "" >> $Report
echo "=> Swap Memory" >> $Report

totswap=$(free -m | awk '/Swap/ {printf "%.2f\n", $2/1024}')
useswap=$(free -m | awk '/Swap/ {printf "%.2f\n", $3/1024}')
freeswap=$(free -m | awk '/Swap/ {printf "%.2f\n", $4/1024}')
freeper=$(echo "$freeswap * 100 / $totswap" | bc)
echo -e "Total\tUsed\tFree\t%Free
${totswap}GB\t${useswap}GB\t${freeswap}GB\t${freeper}%" >> $Report

# cat "$Report" | mail -s "Server Health Check Report" $EMAIL
