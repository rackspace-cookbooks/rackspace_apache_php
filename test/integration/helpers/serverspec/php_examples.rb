shared_examples_for 'php under apache' do |version|
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
    its(:stdout) { should match(/PHP Version #{version}/) }
  end
end

shared_examples_for 'php-fpm' do
  describe service(fpm_service_name) do
    it { should be_enabled }
    it { should be_running }
  end
end

shared_examples_for 'php' do |version|
  describe command('php -v') do
    its(:stdout) { should match(/PHP #{version}/) }
  end
end
