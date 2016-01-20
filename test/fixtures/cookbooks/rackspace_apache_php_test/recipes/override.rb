# Testing cookbook
# Test if the consumer can successfully overidde the default behaviour of our cookbook
include_recipe 'chef-sugar'

# Disable our php-nadler for Apache and our php-fpm pool
node.default['rackspace_apache_php']['php_handler']['enable'] = false
node.default['rackspace_apache_php']['php-fpm']['default_pool']['enable'] = false

# Create a php-fpm pool through the attribute exposed from upstream , if we are on Trusty we use a TCP/IP socket
node.default['php-fpm']['pools'] = {
  override: {
    enable: 'true',
    listen: '127.0.0.1:9001',
    process_manager: 'dynamic',
    max_requests: 5000
  }
} if ubuntu_trusty?

node.default['php-fpm']['pools'] = {
  override: {
    enable: 'true',
    process_manager: 'dynamic',
    max_requests: 5000
  }
} unless ubuntu_trusty?

include_recipe 'rackspace_apache_php::default'

# Create our own php-handler that uses the override pool
apache_conf 'php-handler' do
  source 'php-handler.conf.erb'
  cookbook 'rackspace_apache_php_test'
  enable true
end

# included just to be sure there is no conflicts
include_recipe 'php::default' if node['rackspace_apache_php']['php_packages_install']['enable']
