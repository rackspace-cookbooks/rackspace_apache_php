require 'chefspec'
require 'chefspec/berkshelf'
require_relative 'rackspace_apache_php_shared'

::LOG_LEVEL = ENV['CHEFSPEC_LOG_LEVEL'] ? ENV['CHEFSPEC_LOG_LEVEL'].to_sym : :fatal

def stub_resources
  stub_command('/usr/sbin/httpd -t').and_return(true)
  stub_command('/usr/sbin/apache2 -t').and_return(true)
  stub_command('test -f /etc/httpd/mods-available/fastcgi.conf').and_return(true)
  stub_command('test -d /etc/php-fpm.d || mkdir -p /etc/php-fpm.d').and_return(true)
  stub_command('test -d /etc/php5/fpm/pool.d || mkdir -p /etc/php5/fpm/pool.d').and_return(true)
end

def node_resources(_node)
end

at_exit { ChefSpec::Coverage.report! }
