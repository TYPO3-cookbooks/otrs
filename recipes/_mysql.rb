#
# Cookbook Name:: otrs
# Recipe:: _mysql
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

# generate the password
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['otrs']['database']['password'] = secure_password
node.set_unless['mysql']['server_root_password'] = secure_password


mysql2_chef_gem 'default' do
  action :install
end

mysql_connection_info = {
:host => "127.0.0.1",
:username => 'root',
:password => node['mysql']['server_root_password'],
}

mysql_service "otrs" do
  initial_root_password node['mysql']['server_root_password']
  bind_address mysql_connection_info[:host]
  action [:create, :start]
end

# disable Debian's default MySQL service
service "mysql" do
  action [:stop, :disable]
end

mysql_config "tuning" do
  instance "otrs"
  source "mysql_tuning.cnf.erb"
  notifies :restart, 'mysql_service[otrs]'
  action :create
end

# create otrs database
mysql_database "otrs" do
  connection mysql_connection_info
  action :create
  notifies :run, "execute[otrs_schema]", :immediately
  notifies :run, "execute[otrs_initial_insert]", :immediately
  notifies :run, "execute[otrs_schema-post]", :immediately
end

# db user
mysql_database_user "otrs" do
  connection mysql_connection_info
  password node['otrs']['database']['password']
  database_name 'otrs'
  host 'localhost'
  privileges [:select,:update,:insert,:create,:alter,:drop,:delete,:index]
  action :grant
end

execute "otrs_schema" do
  command "/usr/bin/mysql -h #{mysql_connection_info[:host]} -u root #{node['otrs']['database']['name']} -p#{node['mysql']['server_root_password']} < #{otrs_path}/scripts/database/otrs-schema.mysql.sql"
  sensitive true
  action :nothing
end

execute "otrs_initial_insert" do
  command "/usr/bin/mysql -h #{mysql_connection_info[:host]} -u root #{node['otrs']['database']['name']} -p#{node['mysql']['server_root_password']} < #{otrs_path}/scripts/database/otrs-initial_insert.mysql.sql"
  sensitive true
  action :nothing
end

execute "otrs_schema-post" do
  command "/usr/bin/mysql -h #{mysql_connection_info[:host]} -u root #{node['otrs']['database']['name']} -p#{node['mysql']['server_root_password']} < #{otrs_path}/scripts/database/otrs-schema-post.mysql.sql"
  sensitive true
  action :nothing
end
