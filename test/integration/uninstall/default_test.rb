title "Systemd unit uninstallation integration tests"

describe service('test-service') do
  it { should_not be_installed }
end

describe file('/etc/systemd/system/test-service.service') do
  it { should_not exist }
end
