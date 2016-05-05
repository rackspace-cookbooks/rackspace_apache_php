# Encoding: utf-8
name 'rackspace_apache_php'
maintainer 'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'Installs/Configures rackspace_apache_php'
issues_url 'https://github.com/rackspace-cookbooks/rackspace_apache_php/issues' if respond_to?(:issues_url)
source_url 'https://github.com/rackspace-cookbooks/rackspace_apache_php/' if respond_to?(:source_url)
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.0'

supports 'centos'
supports 'ubuntu'

depends 'apt'
depends 'apache2', '= 3.1.0'
depends 'chef-sugar'
depends 'php', '= 1.5.0'
depends 'php-fpm', '= 0.7.4'
depends 'yum-ius'
