title "Systemd unit launch integration tests"

describe service('test-service') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
