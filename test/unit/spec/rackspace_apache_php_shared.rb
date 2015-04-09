shared_examples_for 'Apache2' do
  it 'includes apache2 required recipes' do
    expect(chef_run).to include_recipe('apache2::default')
    expect(chef_run).to include_recipe('apache2::mod_fastcgi')
    expect(chef_run).to include_recipe('apache2::mod_actions')
  end
end

shared_examples_for 'Apache2 PHP handler' do |distro, apache_version|
  conf_d_path = %w( centos ).include?(distro) ? '/etc/httpd/conf-available' : '/etc/apache2/conf-available'
  it 'configures Apache2 to handle PHP with php-fpm' do
    [
      'AddHandler php5-fcgi .php',
      'Action php5-fcgi /php5-fcgi',
      'Alias /php5-fcgi /var/run/php5-fcgi',
      'FastCgiExternalServer /var/run/php5-fcgi -socket /var/run/php-fpm-www.sock -flush -idle-timeout 1800'
    ].each do |line|
      expect(chef_run).to render_file("#{conf_d_path}/php-handler.conf").with_content(line)
    end
  end
  if apache_version == '2.4'
    it 'sets the approriate Apache 2.4 configuration' do
      [
        '<Directory /var/run>',
        'Require all granted',
        '</Directory>'
      ].each do |line|
        expect(chef_run).to render_file("#{conf_d_path}/php-handler.conf").with_content(line)
      end
    end
  end
end

shared_examples_for 'PHP-FPM' do
  it 'includes php-fpm default recipe' do
    expect(chef_run).to include_recipe('php-fpm::default')
  end
end

shared_examples_for 'Yum IUS repo' do
  it 'configures the appropriate repository' do
    expect(chef_run).to include_recipe('yum-ius')
  end
end

shared_examples_for 'APT php repo' do |version|
  it 'configures the appropriate repository' do
    expect(chef_run).to add_apt_repository("php-#{version}")
  end
  it 'disables Apache install from ondrej repos' do
    expect(chef_run).to add_apt_preference('apache')
  end
end
