# Desired PHP version - we support 5.5 and 5.6
default['rackspace_apache_php']['php_version'] = '5.6'

# Disable the default pool from upstream php-fpm.
# We are adding this here instead of in our recipe to allow the consumer of rackspace_apache_php to override the attribute.
default['php-fpm']['pools'] = {}

# PHP handler configuration
default['rackspace_apache_php']['php_handler']['template'] = 'php-handler.conf.erb'
default['rackspace_apache_php']['php_handler']['cookbook'] = 'rackspace_apache_php'
default['rackspace_apache_php']['php_handler']['enable'] = true
default['rackspace_apache_php']['php-fpm']['default_pool']['enable'] = true

# PHP packages (not PHP-FPM)
default['rackspace_apache_php']['php_packages_install']['enable'] = true
