linux_private_ip = input('linux_private_ip')
linux_public_ip = input('linux_public_ip')

windows_private_ip = input('windows_private_ip')
windows_public_ip = input('windows_public_ip')

password_data = input('password_data')
password = input('password')

describe linux_private_ip do
  it { should_not eq '' }
end
describe linux_public_ip do
  it { should_not eq '' }
end
describe windows_private_ip do
  it { should_not eq '' }
end
describe windows_public_ip do
  it { should_not eq '' }
end
describe password_data do
  it { should_not eq '' }
end
describe password do
  it { should_not eq '' }
end
