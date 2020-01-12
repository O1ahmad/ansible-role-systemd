title "Default role integrated test file"

describe service('test-service') do
  it { should_not be_installed }
  it { should_not be_running }
end

describe file('/etc/systemd/system/test-service.service') do
  it { should_not exist }
end
