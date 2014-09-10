default['otrs']['version'] = "4.0.0.beta1"

default['otrs']['fqdn'] = node['fqdn']

default['otrs']['prefix'] = "/opt"

default['otrs']['database']['host'] = "localhost"
default['otrs']['database']['user'] = "otrs"
default['otrs']['database']['password'] = nil
default['otrs']['database']['name'] = "otrs"

default['otrs']['kernel_config']['email'] = "otrs@otrs.example.org"
default['otrs']['kernel_config']['organization'] = "Example Association"
default['otrs']['kernel_config']['system_id'] = nil

default['otrs']['packages'] = ["iPhoneHandle", "Support"]

# these are at least the default paths for Debian
default['otrs']['apache']['ssl_cert'] = "/etc/ssl/certs/ssl-cert-snakeoil.pem"
default['otrs']['apache']['ssl_key'] = "/etc/ssl/private/ssl-cert-snakeoil.key"

default['apache']['listen_ports'] = [80, 443]