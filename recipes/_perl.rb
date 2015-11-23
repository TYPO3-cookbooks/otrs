#
# Cookbook Name:: otrs
# Recipe:: _perl
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
Install Perl and CPAN modules
#>
=end

include_recipe "perl"

include_recipe "build-essential"

# for GD
package "libgd-gd2-perl"
# for XML::Parser
package "libexpat1-dev"
# for Net::SSL
package "libssl-dev"
# for Archive::Zip
#package "libarchive-zip-perl"

# Required Perl modules
%w{
  Archive::Zip
  Crypt::Eksblowfish::Bcrypt
  GD
  GD::Text
  GD::Graph
  JSON::XS
  Mail::IMAPClient
  Net::DNS
  Net::LDAP
  Net::SSL
  Net::SMTP::SSL
  Net::SMTP::TLS::ButMaintained
  PDF::API2
  Template
  Template::Stash::XS
  Text::CSV_XS
  XML::Parser
  YAML::XS
}.each do |mod|
  cpan_module mod
end