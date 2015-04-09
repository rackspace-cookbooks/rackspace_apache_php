# Desired PHP version
node.default['rackspace_apache_php']['php_version'] = '5.6'

# PHP handler configuration
node.default['rackspace_apache_php']['php_handler']['template'] = 'php-handler.conf.erb'
node.default['rackspace_apache_php']['php_handler']['cookbook'] = 'rackspace_apache_php'
node.default['rackspace_apache_php']['php_handler']['enable'] = true
