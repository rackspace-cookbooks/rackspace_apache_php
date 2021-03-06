shared_examples_for 'Apache2' do |distro, version|
  it 'includes apache2 required recipes' do
    expect(chef_run).to include_recipe('apache2::default')
    expect(chef_run).to include_recipe('apache2::mod_actions')
    unless distro == 'ubuntu' && version == '14.04'
      expect(chef_run).to include_recipe('apache2::mod_fastcgi')
    end
  end
end

shared_examples_for 'Apache2 PHP handler' do |distro, apache_version, suite, port|
  conf_d_path = %w( centos ).include?(distro) ? '/etc/httpd/conf-available' : '/etc/apache2/conf-available'
  if apache_version == '2.2'
    it 'configures Apache 2.2 to handle php requests with php-fpm using mod_fastcgi' do
      [
        '<IfModule mod_fastcgi.c>',
        'AddHandler php5-fcgi .php',
        'Action php5-fcgi /php5-fcgi',
        'Alias /php5-fcgi /var/run/php5-fcgi',
        "FastCgiExternalServer /var/run/php5-fcgi -socket /var/run/php-fpm-#{suite}.sock -flush -idle-timeout 1800",
        '</IfModule>'
      ].each do |line|
        expect(chef_run).to render_file("#{conf_d_path}/php-handler.conf").with_content(line)
      end
    end
  else
    it 'configures Apache 2.4 to handle php requests with php-fpm using mod_proxy_fcgi' do
      [
        '<IfModule mod_proxy_fcgi.c>',
        "ProxyPassMatch ^/(.*\\.php(/.*)?)$ fcgi://127.0.0.1:#{port}/var/www/html/$1",
        'DirectoryIndex /index.php index.php',
        '</IfModule>'
      ].each do |line|
        expect(chef_run).to render_file("#{conf_d_path}/php-handler.conf").with_content(line)
      end
    end
  end
end

shared_examples_for 'PHP-FPM' do |platform, suite|
  it 'includes php-fpm default recipe' do
    expect(chef_run).to include_recipe('php-fpm::default')
  end
  it 'creates the default php-fpm pool' do
    # We cannot test the php_fpm_pool as it is a definition not a resource
    if platform == 'redhat'
      expect(chef_run).to render_file("/etc/php-fpm.d/#{suite}.conf")
    elsif platform == 'ubuntu'
      expect(chef_run).to render_file("/etc/php5/fpm/pool.d/#{suite}.conf")
    else
      expect(chef_run).to render_file("/etc/php5/fpm/pool.d/#{suite}.conf")
    end
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

shared_examples_for 'PHP and PHP-fpm packages version 5.5 CENTOS' do
  it 'installs the correct php and php-fpm packages' do
    ['php55u-devel', 'php55u-cli', 'php55u-pear', 'php55u-fpm'].each do |pkg|
      expect(chef_run).to install_package(pkg)
    end
  end
end

shared_examples_for 'PHP and PHP-fpm packages version 5.6 CENTOS' do
  it 'installs the correct php and php-fpm packages' do
    ['php56u-devel', 'php56u-cli', 'php56u-pear', 'php56u-fpm'].each do |pkg|
      expect(chef_run).to install_package(pkg)
    end
  end
end

shared_examples_for 'PHP-fpm packages without PHP packages, version 5.6 CENTOS' do
  it 'installs the correct php and php-fpm packages' do
    expect(chef_run).to install_package('php56u-fpm')
    expect(chef_run).to_not install_package('php56u-pear')
  end
end

shared_examples_for 'PHP and PHP-fpm packages version 5.5 UBUNTU' do
  it 'installs the correct php and php-fpm packages' do
    %w(php5-cgi php5 php5-dev php5-cli php-pear php5-fpm).each do |pkg|
      expect(chef_run).to install_package(pkg)
    end
  end
end

shared_examples_for 'PHP and PHP-fpm packages version 5.6 UBUNTU' do
  it 'installs the correct php and php-fpm packages' do
    %w(php5-cgi php5 php5-dev php5-cli php-pear php5-fpm).each do |pkg|
      expect(chef_run).to install_package(pkg)
    end
  end
end

shared_examples_for 'PHP-fpm packages without PHP packages, version 5.6 UBUNTU' do
  it 'installs the correct php and php-fpm packages' do
    expect(chef_run).to install_package('php5-fpm')
    expect(chef_run).to_not install_package('php5-cgi')
  end
end
