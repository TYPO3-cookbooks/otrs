Application Data
----------------

Application data resides in the following locations:

- MySQL data base (including article and attachments)
- Config: _SysConfig_ (can be imported/exported from the web interface) is stored in `/opt/otrs/Kernel/Config/Files/ZZZAuto.pm`

Backups
-------

Backups are created every night (in `recipes/_cronjobs.rb`) to `/var/backups/otrs/`.