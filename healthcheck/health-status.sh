#!/bin/bash


echo "Health Status : $(uptime | awk -F'[:, ]+' '{print $NF}' | awk '{if ($1>('$ncpu'+1)) print "Unhealthy";else print "Normal"}')"
