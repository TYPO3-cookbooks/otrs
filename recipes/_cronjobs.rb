#
# Cookbook Name:: otrs
# Recipe:: _cronjobs
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
Setup OTRS cron jobs
#>
=end

cron_d "otrs-daemon" do
  minute "*/5"
  command "#{otrs_path}/bin/otrs.Daemon.pl start >> /dev/null"
  user "otrs"
end
link "#{otrs_path}/var/cron/otrs_daemon" do
  to "#{otrs_path}/var/cron/otrs_daemon.dist"
end

# Backup Cron Job
directory "/var/backups/otrs" do
  recursive true
  owner "otrs"
  recursive
  action :create
end

cron_d "otrs-backup" do
  minute "10"
  hour "0"
  command "#{otrs_path}/scripts/backup.pl -d /var/backups/otrs -t nofullbackup -r 0"
  user "otrs"
end
