## Todo
- [x] Fix sleep and wake issue
- [x] Setup automatic backups (waiting on drive)
- [x] Install simple golang api

## Fixed
- Issue with `./db/wakeup_config.txt` - ThinK `.bak` is what should be used...
- Fixed `DISPLAY` env issue, need to execute all instances of sleep, wake, and kiosk as `digipi` user via `su -c "./<script>" digipi`


