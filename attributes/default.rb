#
# Cookbook Name:: otrs
# Attributes:: default

default['otrs']['version'] = "3.2.16"

default['otrs']['fqdn'] = fqdn

default['otrs']['prefix'] = "/usr/local"

default['otrs']['database']['host'] = "localhost"
default['otrs']['database']['user'] = "otrs"
default['otrs']['database']['password'] = nil
default['otrs']['database']['name'] = "otrs"

default['otrs']['kernel_config']['email'] = "otrs@otrs.example.org"
default['otrs']['kernel_config']['organization'] = "Example Association"
default['otrs']['kernel_config']['system_id'] = nil

default['otrs']['packages'] = ["iPhoneHandle", "Support"]

default['apache']['listen_ports'] = [ 80 ]
