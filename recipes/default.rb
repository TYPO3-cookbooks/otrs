#
# Cookbook Name:: otrs
# Recipe:: default
#
# Copyright 2014, Steffen Gebert / TYPO3 Association
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

::Chef::Recipe.send(:include, OTRS::Helpers)
::Chef::Resource.send(:include, OTRS::Helpers)

otrs_path = node['otrs']['prefix'] + "/otrs"

############################
# System configuration

# create a unix user account for OTRS
user "otrs" do
  comment "OTRS user"
  home otrs_path
  shell "/bin/bash"
  group node['apache']['group']
  system true
end

# Generate random system_id
node.set_unless['otrs']['kernel_config']['system_id'] = rand(9999)

############################
# Perl setup

include_recipe "perl"

include_recipe "build-essential"

# for GD
package "libgd-gd2-perl"
# for XML::Parser
package "libexpat1-dev"
# for Net::SSL
package "libssl-dev"

# Required Perl modules
%w{
  Crypt::Eksblowfish::Bcrypt
  GD
  GD::Text
  GD::Graph
  JSON::XS
  Mail::IMAPClient
  Net::DNS
  Net::LDAP
  Net::SSL
  Net::SMTP::SSL
  Net::SMTP::TLS::ButMaintained
  PDF::API2
  Text::CSV_XS
  XML::Parser
  YAML::XS
}.each do |mod|
  cpan_module mod
end


############################
# Download & extract OTRS

# Download OTRS source code
remote_file "#{Chef::Config[:file_cache_path]}/otrs-#{node['otrs']['version']}.tar.gz" do
  source "http://ftp.otrs.org/pub/otrs/otrs-#{node['otrs']['version']}.tar.gz"
  mode "0644"
  action :create
  notifies :run, "script[extract]", :immediately
  not_if { installed_version_matches?(node['otrs']['version']) }
end

# Extract downloaded file to #{node['otrs']['prefix']}/otrs-x.y.z/
script "extract" do
  interpreter "bash"
  user "root"
  cwd node['otrs']['prefix']
  action :nothing
  code <<-EOH
  tar xfz #{Chef::Config[:file_cache_path]}/otrs-#{node['otrs']['version']}.tar.gz
  EOH
  notifies :run, "execute[SetPermissions]"
end

# Create symlink from otrs/ to otrs-a.b.c./
link otrs_path do
  to "#{otrs_path}-#{node['otrs']['version']}"
end


# this file has the path to OTRS hardcoded
ruby_block "#{otrs_path}/scripts/apache2-perl-startup.pl" do
  block do
    # replace occurrences of /opt/otrs/ in the startup file with the actual path
    file = Chef::Util::FileEdit.new("#{otrs_path}/scripts/apache2-perl-startup.pl")
    file.search_file_replace(/\/opt\/otrs/, otrs_path)
    file.write_file
  end unless node['otrs']['prefix'].equal?("/opt")
end

###########################
# OTRS upgrade

# are we updating to a newer version?
if installed? && ! installed_version_matches?(node['otrs']['version'])
  update_type = patchlevel_upgrade?(node['otrs']['version']) ? "patch" : "minor"

  log "upgrade" do
    message "Upgrading OTRS from #{installed_version?} to #{node['otrs']['version']} (#{update_type})"
  end

  # minor version is 3.2, 3.3 or so..
  bash "#{otrs_path}/scripts/DBUpdate-to-#{minor_version(node['otrs']['version'])}.pl" do
    user node['otrs']['user']
  end
end

############################
# MySql setup

# Install MySQL server

include_recipe "mysql::server"
include_recipe "mysql::client"
include_recipe "database::mysql"

# generate the password
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['otrs']['database']['password'] = secure_password

mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}

# create otrs database
mysql_database 'otrs' do
  connection mysql_connection_info
  action :create
  notifies :run, "execute[otrs_schema]", :immediately
  notifies :run, "execute[otrs_initial_insert]", :immediately
  notifies :run, "execute[otrs_schema-post]", :immediately
end

# db user
mysql_database_user 'otrs' do
  connection mysql_connection_info
  password node['otrs']['database']['password']
  database_name 'otrs'
  host 'localhost'
  privileges [:select,:update,:insert,:create,:alter,:drop,:delete]
  action :grant
end

execute "otrs_schema" do
  command "/usr/bin/mysql -u root #{node['otrs']['database']['name']} -p#{node['mysql']['server_root_password']} < #{otrs_path}/scripts/database/otrs-schema.mysql.sql"
  action :nothing
end

execute "otrs_initial_insert" do
  command "/usr/bin/mysql -u root #{node['otrs']['database']['name']} -p#{node['mysql']['server_root_password']} < #{otrs_path}/scripts/database/otrs-initial_insert.mysql.sql"
  action :nothing
end

execute "otrs_schema-post" do
  command "/usr/bin/mysql -u root #{node['otrs']['database']['name']} -p#{node['mysql']['server_root_password']} < #{otrs_path}/scripts/database/otrs-schema-post.mysql.sql"
  action :nothing
end

##########################
# Configuration files

# install OTRS configuration file
template "#{otrs_path}/Kernel/Config.pm" do
  source "Config.pm.erb"
  owner "otrs"
  group node['apache']['group']
  mode "0664"
  notifies :run, "execute[SetPermissions]"
  notifies :run, "execute[RebuildConfig]"
  notifies :run, "execute[DeleteCache]"
end

template "#{otrs_path}/Kernel/Config/GenericAgent.pm" do
  source "GenericAgent.pm.erb"
  owner "otrs"
  group node['apache']['group']
  mode "0664"
  notifies :run, "execute[SetPermissions]"
  notifies :run, "execute[RebuildConfig]"
  notifies :run, "execute[DeleteCache]"
end

template "#{otrs_path}/Kernel/Config/Files/ZZZAuto.pm" do
  source "SysConfig.pm"
  owner "otrs"
  group node['apache']['group']
  mode "0664"
  notifies :run, "execute[SetPermissions]"
  notifies :run, "execute[RebuildConfig]"
  notifies :run, "execute[DeleteCache]"
end

############################
# OTRS house keeping

# Set file system permissions
execute "SetPermissions" do
  command "bin/otrs.SetPermissions.pl #{otrs_path}-#{node['otrs']['version']} --otrs-user=otrs --otrs-group=#{node['apache']['group']} --web-user=#{node['apache']['user']} --web-group=#{node['apache']['group']}"
  cwd otrs_path
  user "root"
  action :nothing
end

execute "RebuildConfig" do
  command "bin/otrs.RebuildConfig.pl"
  cwd otrs_path
  user "otrs"
  action :nothing
end

execute "DeleteCache" do
  command "bin/otrs.DeleteCache.pl"
  cwd otrs_path
  user "otrs"
  action :nothing
end

############################
# OTRS packages

node['otrs']['packages'].each do |package|
  execute "ReInstallPackage_#{package}" do
    command "bin/otrs.PackageManager.pl -a reinstall -p #{package}"
    cwd otrs_path
    user "otrs"
    only_if "bin/otrs.PackageManager.pl -a list | grep #{package}"
  end
end

##########################
# Apache setup

apache_module "ssl"

# set up mod_perl2
cpan_module "Apache::DBI"
package "libapache2-mod-perl2"


# create vhost
web_app node['otrs']['fqdn'] do
  server_name node['otrs']['fqdn']
  server_aliases ["www.#{node['otrs'].fqdn}"]
  docroot "#{otrs_path}-#{node['otrs']['version']}"
end

# Disable Apache default site
apache_site "000-default" do
  enable false
end

#########################
# Cron jobs

cron_d "DeleteCache" do
  hour "0"
  minute "20"
  weekday "0"
  command "#{otrs_path}/bin/otrs.DeleteCache.pl --expired >> /dev/null"
  user "otrs"
end

cron_d "LoaderCache" do
  hour "0"
  minute "30"
  weekday "0"
  command "#{otrs_path}/bin/otrs.LoaderCache.pl -o delete >> /dev/null"
  user "otrs"
end

#cron_d "fetchmail" do
#  minute "*/5"
#  command "[ -x /usr/bin/fetchmail ] && /usr/bin/fetchmail -a >> /dev/null"
#  user "otrs"
#end

#cron_d "fetchmail_ssl" do
#  minute "*/5"
#  command "[ -x /usr/bin/fetchmail ] && /usr/bin/fetchmail -a --ssl >> /dev/null"
#  user "otrs"
#end

cron_d "GenericAgent_db" do
  minute "*/10"
  command "#{otrs_path}/bin/otrs.GenericAgent.pl -c db >> /dev/null"
  user "otrs"
end

cron_d "GenericAgent" do
  minute "*/20"
  command "#{otrs_path}/bin/otrs.GenericAgent.pl >> /dev/null"
  user "otrs"
end

cron_d "PendingJobs" do
  hour "*/2"
  minute "45"
  command "#{otrs_path}/bin/otrs.PendingJobs.pl >> /dev/null"
  user "otrs"
end

cron_d "cleanup" do
  hour "0"
  minute "10"
  command "#{otrs_path}/bin/otrs.cleanup >> /dev/null"
  user "otrs"
end

cron_d "PostMasterMailbox" do
  minute "*/5"
  command "#{otrs_path}/bin/otrs.PostMasterMailbox.pl >> /dev/null"
  user "otrs"
end

cron_d "RebuildTicketIndex" do
  hour "1"
  minute "1"
  command "#{otrs_path}/bin/otrs.RebuildTicketIndex.pl >> /dev/null"
  user "otrs"
end

cron_d "DeleteSessionIDs" do
  hour "*/2"
  minute "55"
  command "#{otrs_path}/bin/otrs.DeleteSessionIDs.pl --expired >> /dev/null"
  user "otrs"
end

cron_d "UnlockTickets" do
  minute "35"
  command "#{otrs_path}/bin/otrs.UnlockTickets.pl --timeout >> /dev/null"
  user "otrs"
end