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

update_type = patchlevel_upgrade?(node['otrs']['version']) ? "patch" : "minor"
mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}

log "update" do
  message "Updating OTRS from #{installed_version?} to #{node['otrs']['version']} (#{update_type})"
  notifies :reload, "service[apache2]"
end

mysql_database "DBUpdate-to-#{minor_version(node['otrs']['version'])}" do
  connection mysql_connection_info
  database_name "otrs"
  sql { ::File.open("#{otrs_path}/scripts/DBUpdate-to-#{minor_version(node['otrs']['version'])}.mysql.sql").read }
  action :query
end

# minor version is 3.2, 3.3 or so..
bash "#{otrs_path}/scripts/DBUpdate-to-#{minor_version(node['otrs']['version'])}.pl" do
  user node['otrs']['user']
end

mysql_database "DBUpdate-to-#{minor_version(node['otrs']['version'])}-post" do
  connection mysql_connection_info
  database_name "otrs"
  sql { ::File.open("#{otrs_path}/scripts/DBUpdate-to-#{minor_version(node['otrs']['version'])}-post.mysql.sql").read }
  action :query
  only_if { ::File.exists?("#{otrs_path}/scripts/DBUpdate-to-#{minor_version(node['otrs']['version'])}-post.mysql.sql") }
end
