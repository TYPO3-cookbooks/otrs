#
# Cookbook Name:: otrs
# Recipe:: _apache
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
Install and configure Apache HTTPD for OTRS
#>
=end

apache_module "ssl"

# set up mod_perl2
cpan_module "Apache::DBI"
package "libapache2-mod-perl2"


# create vhost
web_app node['otrs']['fqdn'] do
  cookbook node['otrs']['apache']['vhost_source'] || "otrs"
  server_name node['otrs']['fqdn']
  server_aliases ["www.#{node['otrs']['fqdn']}"]
  docroot otrs_path
end

# Disable Apache default site
apache_site "000-default" do
  enable false
end