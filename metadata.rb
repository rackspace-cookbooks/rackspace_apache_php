# Encoding: utf-8
name 'rackspace_apache_php'
maintainer 'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'Installs/Configures rackspace_apache_php'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

supports 'centos'
supports 'ubuntu'

depends 'apt'
depends 'apache2', '= 3.1.0'
depends 'chef-sugar'
depends 'php', '= 1.5.0'
depends 'php-fpm', '= 0.7.4'
depends 'yum-ius'
