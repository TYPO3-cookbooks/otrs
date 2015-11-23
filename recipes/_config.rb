#
# Cookbook Name:: otrs
# Recipe:: _config
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
Deployment of OTRS Configuration files (Kernel/Config.pm, GenericAgent.pm)
#>
=end

# install OTRS configuration file
template "Kernel/Config.pm" do
  path "#{otrs_path}/Kernel/Config.pm"
  source "Config.pm.erb"
  owner "otrs"
  group node['apache']['group']
  mode "0664"
  notifies :run, "execute[RebuildConfig]"
  notifies :run, "execute[DeleteCache]"
end

# This file existed only in OTRS <= 4
template "Kernel/Config/GenericAgent.pm" do
  path "#{otrs_path}/Kernel/Config/GenericAgent.pm"
  source "GenericAgent.pm.erb"
  owner "otrs"
  group node['apache']['group']
  mode "0664"
  action (node['otrs']['version'].to_i < 5) ? :create : :delete
  notifies :run, "execute[RebuildConfig]"
  notifies :run, "execute[DeleteCache]"
end