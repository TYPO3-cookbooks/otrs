#
# Cookbook Name:: otrs
# Recipe:: _helpers
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

# Set file system permissions
execute "SetPermissions" do
  command "bin/otrs.SetPermissions.pl #{otrs_path}-#{node['otrs']['version']} --otrs-user=otrs --otrs-group=#{node['apache']['group']} --web-user=#{node['apache']['user']} --web-group=#{node['apache']['group']}"
  cwd otrs_path
  user "root"
  action :nothing
end

execute "RebuildConfig" do
  command node['otrs']['version'].to_i < 5 ? "bin/otrs.RebuildConfig.pl" : "true"
  cwd otrs_path
  user "otrs"
  group node['apache']['group']
  action :nothing
end

execute "DeleteCache" do
  command node['otrs']['version'].to_i < 5 ? "bin/otrs.DeleteCache.pl" : "true"
  cwd otrs_path
  user "otrs"
  group node['apache']['group']
  action :nothing
end
