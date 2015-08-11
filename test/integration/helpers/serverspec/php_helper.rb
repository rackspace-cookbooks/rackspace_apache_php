shared_examples_for 'php under apache' do |version, suite|
  describe page_returns('http://localhost/phpinfo.php') do
    index_php_path = "#{get_helper_data_value(suite, :docroot)}/phpinfo.php"
    before do
      File.open(index_php_path, 'w') { |file| file.write('<?php phpinfo(); ?>') }
    end
    phpinfo = %w(
      FPM\/FastCGI
    )
    phpinfo.each do |line|
      its(:content) { should match(/#{line}/) }
    end
    its(:content) { should match(/PHP Version #{version}/) }
  end
end

shared_examples_for 'php' do |version|
  describe command('php -v') do
    its(:stdout) { should match(/PHP #{version}/) }
  end
end
