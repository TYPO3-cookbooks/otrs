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