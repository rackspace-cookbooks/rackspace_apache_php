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
