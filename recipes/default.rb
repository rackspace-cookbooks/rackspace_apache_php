# Encoding: utf-8
#
# Cookbook Name:: rackspace_apache_php
# Recipe:: default
#
# Copyright 2014, Rackspace
#

# PHP-FPM
include_recipe 'php-fpm::default'

# APACHE
include_recipe 'apache2::mod_actions'
include_recipe 'apache2::mod_fastcgi'

apache_conf 'php-handler' do
  source node['rackspace_apache_php']['php_handler']['template']
  cookbook node['rackspace_apache_php']['php_handler']['cookbook']
  enable node['rackspace_apache_php']['php_handler']['enable']
end

# TODO 
# All the logic to set the correct PHP version / Package / Repo 
# Like this fa2be8a5601b4e3a7d3ab2553098300da754efc3
# * correct repo
# * correct downgrade if required
# * change package name if required
# * change php-fpm package name if required
# * downgrade / upgrade Apache if required
