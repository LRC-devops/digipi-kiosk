# DigiPi Kiosk
Digipi Kiosk is a collection of scripts and config files required by the **LRC Digital Signage System**, AKA the DigiSign system. The *DigiPi* is the RespberrypiOS which hosts the DigiSign for Web system.

## `/crontab`
This directory is really only to be used by a system API.
All crontabs are owned and executed by the root user. To access/edit: `sudo crontab -u root -e`
### `/backups` 
Holds dated backups of the crontabs

## `backup_cron` 
is a script which backups the current cron to the `backups` directory.

## `/db`
Holds varios log files and config files such as: 
```
log_backups/      # log backups
config.txt        # wake cycle, resolution, and such
resolution.txt    # depreciated
shutdown.log      # Shutdown and wake cycle logs
sleep.log         # sleep and wake logs
wakeup_config.txt # depreciated
```

## `/healthcheck`
Holds a verbose `health-check.sh` script which stores reports in `/healthcheck/reports`
Also holds a succinct `health-status.sh` file for simple health-status outputting

## Scripts

Varios scripts include: 
```
kiosk.sh
shutdown
sleep_mode
wake_mode
```

These are the main controllers of the system, mostly executed by the `root` crontab.
Each contains relative documnentation at the top of the script.
