control 'otrs-1' do
  title 'OTRS Setup'
  desc ''

  describe directory('/opt/otrs') do
    it { should exist }
  end

  describe file('/opt/otrs/Kernel/Config/Files/ZZZAuto.pm') do
    before do
      skip unless file('/opt/otrs/Kernel/Config/Files/ZZZAuto.pm').exist?
    end

    its('owner') { should eq 'otrs' }
    its('group') { should eq 'www-data'}
    its('mode') { should eq 0660 }
  end

  describe file('/opt/otrs/Kernel/Config/Files/ZZZAAuto.pm') do
    it { should exist }
    its('owner') { should eq 'otrs' }
    its('group') { should eq 'www-data'}
    its('mode') { should eq 0660 }
  end

end

control 'otrs-2' do
  title 'OTRS Web'

  describe port(80) do
    it { should be_listening }
    its('protocols') { should include 'tcp6'}
  end

  describe command('curl http://otrs.vagrant') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include '<meta http-equiv="refresh" content="0; URL=/otrs/index.pl" />' }
  end

  describe command('curl http://otrs.vagrant/otrs/index.pl') do
    its('exit_status') { should eq 0 }
    its('stdout') { should include '<input type="text" id="PasswordUser" name="User"' }
  end

end