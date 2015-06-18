shared_examples_for 'php under apache' do |version, suite|
  describe command('wget -qO- localhost:80/phpinfo.php') do
    index_php_path = "#{get_test_data_value(os[:family].to_sym, suite, :docroot)}/phpinfo.php"
    before do
      File.open(index_php_path, 'w') { |file| file.write('<?php phpinfo(); ?>') }
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

shared_examples_for 'php' do |version|
  describe command('php -v') do
    its(:stdout) { should match(/PHP #{version}/) }
  end
end
