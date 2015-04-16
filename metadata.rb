# Encoding: utf-8
name 'rackspace_apache_php'
maintainer 'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'Installs/Configures rackspace_apache_php'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.2'

depends 'apt'
depends 'apache2', '~> 3.0'
depends 'chef-sugar'
depends 'php', '~> 1.5'
depends 'php-fpm', '~> 0.7'
depends 'yum-ius'
