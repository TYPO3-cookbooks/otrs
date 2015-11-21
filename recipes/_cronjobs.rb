#
# Cookbook Name:: otrs
# Recipe:: _cronjobs
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

if node['otrs']['version'].to_i < 5

  cron_d "DeleteCache" do
    hour "0"
    minute "20"
    weekday "0"
    command "#{otrs_path}/bin/otrs.DeleteCache.pl --expired >> /dev/null"
    user "otrs"
  end
  
  cron_d "LoaderCache" do
    hour "0"
    minute "30"
    weekday "0"
    command "#{otrs_path}/bin/otrs.LoaderCache.pl -o delete >> /dev/null"
    user "otrs"
  end
  
  cron_d "fetchmail" do
    minute "*/5"
    command "[ -x /usr/bin/fetchmail ] && /usr/bin/fetchmail -a >> /dev/null"
    user "otrs"
    action :nothing
  end
  
  cron_d "fetchmail_ssl" do
    minute "*/5"
    command "[ -x /usr/bin/fetchmail ] && /usr/bin/fetchmail -a --ssl >> /dev/null"
    user "otrs"
    action :nothing
  end
  
  cron_d "GenericAgent_db" do
    minute "*/10"
    command "#{otrs_path}/bin/otrs.GenericAgent.pl -c db >> /dev/null"
    user "otrs"
  end
  
  cron_d "GenericAgent" do
    minute "*/20"
    command "#{otrs_path}/bin/otrs.GenericAgent.pl >> /dev/null"
    user "otrs"
  end
  
  cron_d "PendingJobs" do
    hour "*/2"
    minute "45"
    command "#{otrs_path}/bin/otrs.PendingJobs.pl >> /dev/null"
    user "otrs"
  end
  
  cron_d "cleanup" do
    hour "0"
    minute "10"
    command "#{otrs_path}/bin/otrs.cleanup >> /dev/null"
    user "otrs"
  end
  
  cron_d "PostMasterMailbox" do
    minute "*/5"
    command "#{otrs_path}/bin/otrs.PostMasterMailbox.pl >> /dev/null"
    user "otrs"
  end
  
  cron_d "RebuildTicketIndex" do
    hour "1"
    minute "1"
    command "#{otrs_path}/bin/otrs.RebuildTicketIndex.pl >> /dev/null"
    user "otrs"
  end
  
  cron_d "DeleteSessionIDs" do
    hour "*/2"
    minute "55"
    command "#{otrs_path}/bin/otrs.DeleteSessionIDs.pl --expired >> /dev/null"
    user "otrs"
  end
  
  cron_d "UnlockTickets" do
    minute "35"
    command "#{otrs_path}/bin/otrs.UnlockTickets.pl --timeout >> /dev/null"
    user "otrs"
  end

else

  # OTRS starting from version 5 has this Daemon
  cron_d "Daemon" do
    minute "*/5"
    command "#{otrs_path}/bin/otrs.Daemon.pl start >> /dev/null"
    user "otrs"
  end
  link "#{otrs_path}/var/cron/otrs_daemon" do
    to "#{otrs_path}/var/cron/otrs_daemon.dist"
  end

end
