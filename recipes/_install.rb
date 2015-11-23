#
# Cookbook Name:: otrs
# Recipe:: _install
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
Deployment of the OTRS application itself. This will download the .tar.gz,
extract it to the given prefix (i.e. /opt/otrs-x.y.z) and symlink it to
<prefix>/otrs.
#>
=end

# create a unix user account for OTRS
user "otrs" do
  comment "OTRS user"
  home otrs_path
  shell "/bin/bash"
  group node['apache']['group']
  system true
end

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
  code "tar xfz #{Chef::Config[:file_cache_path]}/otrs-#{node['otrs']['version']}.tar.gz"
  cwd node['otrs']['prefix']
  user "root"
  action :nothing
  notifies :create, "link[#{otrs_path}]",         :immediately # the order here matters..
  notifies :create, "template[Kernel/Config.pm]", :immediately # config has to exist,
  notifies :run,    "execute[SetPermissions]",    :immediately # before SetPermissions is run
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
