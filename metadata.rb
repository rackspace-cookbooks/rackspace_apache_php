# Encoding: utf-8
name 'rackspace_apache_php'
maintainer 'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'Installs/Configures rackspace_apache_php'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.1'

depends 'apache2'
depends 'chef-sugar'
depends 'php-fpm'
depends 'yum-ius'
