# Description

This cookbook deploys OTRS (Open Ticket Request System) through Chef.

Apache HTTPD as well as MySQL are automatically installed an configured.

Further, automatic updates (by executing OTRS' update scripts) are supported.

Please install your preferred MTA (e.g. Postfix) on your own.
# Requirements

## Platform:

* debian

## Cookbooks:

* apache2 (= 3.1.0)
* build-essential (= 2.0.6)
* cron (= 1.4.3)
* database (= 2.3.1)
* mysql (= 5.6.3)
* perl (= 1.2.4)

# Attributes

* `node['otrs']['version']` - OTRS version to install. Defaults to `5.0.3`.
* `node['otrs']['fqdn']` - Fully qualified domain name. Defaults to `node['fqdn']`.
* `node['otrs']['prefix']` - Installation path. Defaults to `/opt`.
* `node['otrs']['database']['host']` - Database host. Defaults to `localhost`.
* `node['otrs']['database']['user']` - Database user. Defaults to `otrs`.
* `node['otrs']['database']['password']` - Database password. Defaults to `nil`.
* `node['otrs']['database']['name']` - Database name. Defaults to `otrs`.
* `node['otrs']['upgrade']['automatic']` - Perform automatic updates? If `false`, the update scripts have to be run manually. Defaults to `true`.
* `node['otrs']['kernel_config']['email']` - Admin email address. Defaults to `otrs@otrs.example.org`.
* `node['otrs']['kernel_config']['organization']` - Organization name. Defaults to `Example Association`.
* `node['otrs']['kernel_config']['system_id']` - OTRS System ID, will be generated automatically, if `nil`. Defaults to `nil`.
* `node['otrs']['packages']` - OTRS Packages to install. Defaults to `[ ... ]`.
* `node['otrs']['apache']['ssl_cert']` - SSL certificate path (works on Debian). Defaults to `/etc/ssl/certs/ssl-cert-snakeoil.pem`.
* `node['otrs']['apache']['ssl_key']` - SSL key path (works on Debian). Defaults to `/etc/ssl/private/ssl-cert-snakeoil.key`.
* `node['otrs']['apache']['vhost_source']` - Source cookbook of the Apache vhost template. Defaults to `nil`.
* `node['apache']['listen_ports']` - Ports to which apache should listen to. Defaults to `[ ... ]`.

# Recipes

* [otrs::default](#otrsdefault) - Default recipe that organizes everything.

## otrs::default

Default recipe that organizes everything. Sets up all components, triggers updates, makes happy.
Hopefully.

Application Data
----------------

Application data resides in the following locations:

- MySQL data base (including article and attachments)
- Config: _SysConfig_ (can be imported/exported from the web interface) is stored in `/opt/otrs/Kernel/Config/Files/ZZZAuto.pm`
- GnuPG: `/opt/otrs-gnupg` for private GPG key

Backups
-------

Backups are created every night (in `recipes/_cronjobs.rb`) to `/var/backups/otrs/`.

# License and Maintainer

Maintainer:: TYPO3 Association (<steffen.gebert@typo3.org>)
Source:: https://github.com/TYPO3-cookbooks/otrs

License:: Apache 2.0
