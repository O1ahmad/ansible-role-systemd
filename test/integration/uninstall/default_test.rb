title "Systemd unit uninstallation integration tests"

describe file('/etc/systemd/system/test-service.service') do
  it { should_not exist }
end
