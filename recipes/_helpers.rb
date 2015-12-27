#
# Cookbook Name:: otrs
# Recipe:: _helpers
#
# Copyright 2015, TYPO3 Association
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
Some helper resources that are notified at other places (SetPermissions.pl, etc.)
#>
=end

# Set file system permissions
set_permissions_file = (node['otrs']['version'].to_i < 3) ? "bin/SetPermissions.pl" : "bin/otrs.SetPermissions.pl"
execute "SetPermissions" do
  command "#{set_permissions_file} #{otrs_path}-#{node['otrs']['version']} --otrs-user=otrs --otrs-group=#{node['apache']['group']} --web-user=#{node['apache']['user']} --web-group=#{node['apache']['group']}"
  cwd otrs_path
  user "root"
  action :nothing
end

execute "RebuildConfig" do
  command node['otrs']['version'].to_i < 5 ? "bin/otrs.RebuildConfig.pl" : "bin/otrs.Console.pl Maint::Config::Rebuild"
  cwd otrs_path
  user "otrs"
  group node['apache']['group']
  action :nothing
end

execute "DeleteCache" do
  command (node['otrs']['version'].to_i == 3 || node['otrs']['version'].to_i == 4) ? "bin/otrs.DeleteCache.pl" : "true"
  cwd otrs_path
  user "otrs"
  group node['apache']['group']
  action :nothing
end
