#
# Cookbook Name:: otrs
# Recipe:: update
#
# Copyright 2014, TYPO3 Association
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

=begin
#<
OTRS in-place upgrades
======================

This recipe feels a bit hacky, but it seems to do its job
as long as there are only two (or three) steps in the upgrade
process: DBUpdate*.sql, DBUpdate*.pl, (DBUpdate*-post.sql)

File name structure:
OTRS <= 3.x used DBUpdate-to-<major>.<minor>.mysql.sql format
OTRS >= 4.x uses DBUpdate-to-<major>.mysql.sql format
handle both here, just execute what exists :-)
#>
=end

version = node['otrs']['version']

Chef::Log.warn "Updating OTRS from #{installed_version?} to #{version}"

log "update-notifiy-services" do
  message "Notifying other services to restart"
  notifies :reload, "service[apache2]"
end

# stop the OTRS daemon. We will not start it, as it has to run as
# otrs user. The cron job will restart it for us!
service "otrs.Daemon.pl" do
  start_command "su -c \"#{otrs_path}/bin/otrs.Daemon.pl start\" -s /bin/bash otrs"
  stop_command  "su -c \"#{otrs_path}/bin/otrs.Daemon.pl stop\" -s /bin/bash otrs"
  supports :start => true, :stop => true
  action :stop
end


###########################################
# Copy over SysConfig
# (otherwise it will be lost after upgrade)
###########################################

old_sysconfig_file = File.join(node['otrs']['prefix'], "otrs-#{installed_version?}", "/Kernel/Config/Files/ZZZAuto.pm")

if File.exists?(old_sysconfig_file)
  # as File.read would fail reading the file during compile time, we have to check for file existance at higher level
  file "Kernel/Config/Files/ZZZAuto.pm" do
    path"#{otrs_path}/Kernel/Config/Files/ZZZAuto.pm"
    content File.read(old_sysconfig_file)
    owner "otrs"
    group node['apache']['group']
  end
end

##############################
# DBUpdate-to-X(.Y).mysql.sql
##############################

if major_upgrade?(version)

  Chef::Log.warn "Update type is major version"

  execute "DBUpdate-to-#{major_version(version)}.sql" do
    command "/usr/bin/mysql -u root #{node['otrs']['database']['name']} -p#{node['mysql']['server_root_password']} < #{otrs_path}/scripts/DBUpdate-to-#{major_version(version)}.mysql.sql"
    sensitive true
    only_if { ::File.exists?("#{otrs_path}/scripts/DBUpdate-to-#{major_version(version)}.mysql.sql") }
  end

  execute "DBUpdate-to-#{major_version(version)}.pl" do
    command "#{otrs_path}/scripts/DBUpdate-to-#{major_version(version)}.pl"
    user "otrs"
    only_if { ::File.exists?("#{otrs_path}/scripts/DBUpdate-to-#{major_version(version)}.pl") }
  end

  execute "DBUpdate-to-#{major_version(version)}-post.sql" do
    command "/usr/bin/mysql -u root #{node['otrs']['database']['name']} -p#{node['mysql']['server_root_password']} < #{otrs_path}/scripts/DBUpdate-to-#{major_version(version)}-post.mysql.sql"
    sensitive true
    only_if { ::File.exists?("#{otrs_path}/scripts/DBUpdate-to-#{major_version(version)}-post.mysql.sql") }
  end

end


if minor_upgrade?(version)

  Chef::Log.warn "Update type is minor version"

  execute "DBUpdate-to-#{minor_version(version)}.sql" do
    command "/usr/bin/mysql -u root #{node['otrs']['database']['name']} -p#{node['mysql']['server_root_password']} < #{otrs_path}/scripts/DBUpdate-to-#{minor_version(version)}.mysql.sql"
    sensitive true
    only_if { ::File.exists?("#{otrs_path}/scripts/DBUpdate-to-#{minor_version(version)}.mysql.sql") }
  end

  execute "DBUpdate-to-#{minor_version(version)}.pl" do
    command "#{otrs_path}/scripts/DBUpdate-to-#{minor_version(version)}.pl"
    user "otrs"
    only_if { ::File.exists?("#{otrs_path}/scripts/DBUpdate-to-#{minor_version(version)}.pl") }
  end

  execute "DBUpdate-to-#{minor_version(version)}-post.sql" do
    command "/usr/bin/mysql -u root #{node['otrs']['database']['name']} -p#{node['mysql']['server_root_password']} < #{otrs_path}/scripts/DBUpdate-to-#{minor_version(version)}-post.mysql.sql"
    sensitive true
    only_if { ::File.exists?("#{otrs_path}/scripts/DBUpdate-to-#{minor_version(version)}-post.mysql.sql") }
  end

end