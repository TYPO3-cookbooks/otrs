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
log "update" do
  message "Updating OTRS from #{installed_version?} to #{version}"
  notifies :reload, "service[apache2]"
end

##############################
# DBUpdate-to-X(.Y).mysql.sql
##############################
execute "DBUpdate-to-#{major_version(version)}.sql" do
  command "/usr/bin/mysql -u root #{node['otrs']['database']['name']} -p#{node['mysql']['server_root_password']} < #{otrs_path}/scripts/DBUpdate-to-#{major_version(version)}.mysql.sql"
  sensitive true
  only_if { ::File.exists?("#{otrs_path}/scripts/DBUpdate-to-#{major_version(version)}.mysql.sql") }
end

execute "DBUpdate-to-#{minor_version(version)}.sql" do
  command "/usr/bin/mysql -u root #{node['otrs']['database']['name']} -p#{node['mysql']['server_root_password']} < #{otrs_path}/scripts/DBUpdate-to-#{minor_version(version)}.mysql.sql"
  sensitive true
  only_if { ::File.exists?("#{otrs_path}/scripts/DBUpdate-to-#{minor_version(version)}.mysql.sql") }
end

##############################
# DBUpdate-to-X(.Y).pl
##############################
execute "DBUpdate-to-#{major_version(version)}.pl" do
  command "#{otrs_path}/scripts/DBUpdate-to-#{major_version(version)}.pl"
  sensitive true
  user "otrs"
  only_if { ::File.exists?("#{otrs_path}/scripts/DBUpdate-to-#{major_version(version)}.pl") }
end

execute "DBUpdate-to-#{minor_version(version)}.pl" do
  command "#{otrs_path}/scripts/DBUpdate-to-#{minor_version(version)}.pl"
  sensitive true
  user "otrs"
  only_if { ::File.exists?("#{otrs_path}/scripts/DBUpdate-to-#{minor_version(version)}.pl") }
end

##############################
# DBUpdate-to-X(.Y)-post.mysq.sql
##############################
execute "DBUpdate-to-#{major_version(version)}-post.sql" do
  command "/usr/bin/mysql -u root #{node['otrs']['database']['name']} -p#{node['mysql']['server_root_password']} < #{otrs_path}/scripts/DBUpdate-to-#{major_version(version)}-post.mysql.sql"
  sensitive true
  only_if { ::File.exists?("#{otrs_path}/scripts/DBUpdate-to-#{major_version(version)}-post.mysql.sql") }
end
execute "DBUpdate-to-#{minor_version(version)}-post.sql" do
  command "/usr/bin/mysql -u root #{node['otrs']['database']['name']} -p#{node['mysql']['server_root_password']} < #{otrs_path}/scripts/DBUpdate-to-#{minor_version(version)}-post.mysql.sql"
  sensitive true
  only_if { ::File.exists?("#{otrs_path}/scripts/DBUpdate-to-#{minor_version(version)}-post.mysql.sql") }
end
