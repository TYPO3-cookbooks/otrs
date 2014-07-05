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

# Generate random system_id
node.set_unless['otrs']['kernel_config']['system_id'] = rand(9999)

# Perl setup
include_recipe "otrs::_perl"

# Download & extract OTRS
include_recipe "otrs::_install"

# OTRS upgrade
# are we updating to a newer version?
if installed? && ! installed_version_matches?(node['otrs']['version'])
  include_recipe "otrs::_update"
end

# MySql setup
include_recipe "otrs::_mysql"

##########################
# Configuration files
include_recipe "otrs::_config"

############################
# OTRS helper scripts
include_recipe "otrs::_helpers"

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

# Apache setup
include_recipe "otrs::_apache"
# Cron jobs
include_recipe "otrs::_cronjobs"

