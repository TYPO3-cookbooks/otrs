# Description

Installs/Configures OTRS

# Requirements

## Platform:

*No platforms defined*

## Cookbooks:

* apache2
* build-essential
* database
* mysql
* perl

# Attributes

* `node['otrs']['version']`
* `node['otrs']['fqdn']` -  Defaults to `fqdn`.
* `node['otrs']['prefix']` -  Defaults to `/usr/local`.
* `node['otrs']['database']['host']` -  Defaults to `localhost`.
* `node['otrs']['database']['user']` -  Defaults to `otrs`.
* `node['otrs']['database']['password']` -  Defaults to `nil`.
* `node['otrs']['database']['name']` -  Defaults to `otrs`.
* `node['otrs']['kernel_config']['email']` -  Defaults to `otrs@otrs.example.org`.
* `node['otrs']['kernel_config']['organization']` -  Defaults to `Example Association`.
* `node['otrs']['kernel_config']['system_id']` -  Defaults to `nil`.
* `node['otrs']['packages']` -  Defaults to `[ ... ]`.
* `node[:apache][:listen_ports]` -  Defaults to `[ ... ]`.

# Recipes

* otrs::default

# License and Maintainer

Maintainer:: TYPO3 Association (<steffen.gebert@typo3.org>)

License:: Apache 2.0
