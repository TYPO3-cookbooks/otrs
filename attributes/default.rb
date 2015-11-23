#<> OTRS version to install
default['otrs']['version'] = "5.0.3"

#<> Fully qualified domain name
default['otrs']['fqdn'] = node['fqdn']

#<> Installation path
default['otrs']['prefix'] = "/opt"

#<> Database host
default['otrs']['database']['host'] = "localhost"
#<> Database user
default['otrs']['database']['user'] = "otrs"
#<> Database password
default['otrs']['database']['password'] = nil
#<> Database name
default['otrs']['database']['name'] = "otrs"

#<> Perform automatic updates? If `false`, the update scripts have to be run manually
default['otrs']['upgrade']['automatic'] = true

#<> Admin email address
default['otrs']['kernel_config']['email'] = "otrs@otrs.example.org"
#<> Organization name
default['otrs']['kernel_config']['organization'] = "Example Association"
#<> OTRS System ID, will be generated automatically, if `nil`
default['otrs']['kernel_config']['system_id'] = nil

#<> OTRS Packages to install
default['otrs']['packages'] = ["iPhoneHandle", "Support"]

#<> SSL certificate path (works on Debian)
default['otrs']['apache']['ssl_cert'] = "/etc/ssl/certs/ssl-cert-snakeoil.pem"
#<> SSL key path (works on Debian)
default['otrs']['apache']['ssl_key'] = "/etc/ssl/private/ssl-cert-snakeoil.key"

#<> Source cookbook of the Apache vhost template
default['otrs']['apache']['vhost_source'] = nil

#<> Ports to which apache should listen to
default['apache']['listen_ports'] = [80, 443]