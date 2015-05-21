require 'spec_helper'
require 'platform_helper'

# Apache
describe service(apache_service_name) do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

## test modules
%w( actions fastcgi ).each do |mod|
  describe command("#{apache2ctl} -M") do
    its(:stdout) { should match(/^ #{mod}_module/) }
  end
end

## test configuration syntax
describe command("#{apache2ctl} -t") do
  its(:exit_status) { should eq 0 }
end

describe file(docroot) do
  it { should be_directory }
end

# PHP
describe 'PHP configuration' do
  it_behaves_like 'php under apache', 5.6
  it_behaves_like 'php', 5.6
  it_behaves_like 'php-fpm'
end
