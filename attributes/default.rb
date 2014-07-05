default['otrs']['version'] = "3.3.7"

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

default['apache']['listen_ports'] = [ 80 ]
