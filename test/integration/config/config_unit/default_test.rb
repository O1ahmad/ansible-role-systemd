title "Systemd unit configuration integration tests"

describe service('test-service') do
  it { should be_installed }
end

describe file('/etc/systemd/system/test-service.service') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0644' }
  its('content') { should match("Description=") }
  its('content') { should match("ExecStart=") }
  its('content') { should match("WantedBy=") }
end

describe file('/etc/systemd/system/test-service.socket') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0644' }
  its('content') { should match("Description=") }
  its('content') { should match("ListenStream=") }
  its('content') { should match("WantedBy=") }
end

describe file('/run/systemd/system/tmp-stdin.mount') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0644' }
  its('content') { should match("Description=") }
  its('content') { should match("What=") }
  its('content') { should match("WantedBy=") }
end

describe file('/etc/systemd/system/test-target.target') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0644' }
  its('content') { should match("Description=") }
  its('content') { should match("Wants=") }
  its('content') { should match("PartOf=") }
end
