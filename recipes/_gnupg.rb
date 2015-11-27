#
# Cookbook Name:: otrs
# Recipe:: _gnupg
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
Setup the ~/.gnupg directory to use PGP/GPG.

As the home directory of the OTRS user is symlinked to the current OTRS release, we cannot
simply put the .gnupg directory there, as this would be unavailable after any update.
Therefore, symlink ~/.gnupg of the OTRS user to node['otrs']['prefix']/otrs-gnupg
#>
=end

otrs_gnupg_dir = "#{node['otrs']['prefix']}/otrs-gnupg"

directory otrs_gnupg_dir do
  owner node['apache']['user']
  group node['apache']['group']
  mode 00700
end

link "#{otrs_path}/.gnupg" do
  to otrs_gnupg_dir
end