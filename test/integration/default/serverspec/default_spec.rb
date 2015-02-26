require 'spec_helper'

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
  describe command('wget -qO- localhost:80/phpinfo.php') do
    index_php_path = "#{docroot}/phpinfo.php"
    before do
      File.open(index_php_path, 'w') { |file| file.write('<?php phpinfo(); ?>') }
      ` a2ensite default `
      ` service #{apache_service_name} reload `
    end
    phpinfo = %w(
      FPM\/FastCGI
    )
    phpinfo.each do |line|
      its(:stdout) { should match(/#{line}/) }
    end
    its(:stdout) { should match(/PHP Version 5/) }
  end
end

# PHP-FPM
describe service(fpm_service_name) do
  it { should be_enabled }
  it { should be_running }
end
