title "Default role integrated test file"

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

describe service('type-only-section') do
  it { should be_installed }
end

describe file('/etc/systemd/system/type-only-section.service') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0644' }
  its('content') { should_not match("Description") }
  its('content') { should_not match("Install") }
  its('content') { should match("ExecStart=") }
end
