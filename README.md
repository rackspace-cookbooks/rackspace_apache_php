[![Circle CI](https://circleci.com/gh/rackspace-cookbooks/rackspace_apache_php.svg?style=svg)](https://circleci.com/gh/rackspace-cookbooks/rackspace_apache_php)

# rackspace_apache_php-cookbook

A cookbook to provide a web server able to serve php pages with Apache and PHP fpm.
It relies on [apache2 cookbook](https://github.com/svanzoest-cookbooks/apache2/) and [php-fpm](https://github.com/yevgenko/cookbook-php-fpm). Those cookbooks are pinned on well known working minor version to prevent breaking changes.
In addition (even if this is not a requirement), the cookbook will install php packages through [PHP cookbook](https://github.com/opscode-cookbooks/php). Indeed most of the time you will need `php::default` in your role which will conflict with the `php-fpm` package if they are different.
You can disable the installation of php packages with `node['rackspace_apache_php']['php_packages_install']['enable']`.

## ***
## NOTE: Support for PHP 5.4 was dropped in v1.0.0
## ***

## Supported Platforms

* Centos 6.7
* Ubuntu 12.04
* Ubuntu 14.04

## Supported PHP versions

* 5.5
* 5.6

## Attributes

* `node['rackspace_apache_php']['php_version']` : Which PHP version to install, default to PHP 5.6
* `node['rackspace_apache_php']['php-fpm']['default_pool']['enable']` : Should it enable a default PHP-FPM pool which listens on a unix socket, defaults to 'true' (change it to false if you want to manage your own PHP-FPM pools)
* `node['rackspace_apache_php']['php_handler']['enable']` : Should it enable Apache PHP handler (applied in "conf.d", so it will be available in EVERY vhost, if you want to manage your own handler configuration, set this attribute to false)
* `node['rackspace_apache_php']['php_handler']['cookbook']` : Where to find the handler configuration , default to `rackspace_apache_php cookbook`
* `node['rackspace_apache_php']['php_handler']['template']` : Where to find the handler configuration , default to `php-handler.conf.erb`

## Usage

Place a dependency on the rackspace_apache_php cookbook in your cookbook's metadata.rb
```
depends 'rackspace_apache_php'
```
Then, add `rackspace_apache_php::default` to your runlist

```
# myrecipe.rb
include_recipe 'rackspace_apache_php::default'
```

or

```
# roles/myrole.rb
name "myrole"
description "apache and php role"
run_list(
  "rackspace_apache_php::default"
)
```

You can change any of the `apache2`,`php-fpm` and `php` cookbook attributes to tune rackspace_apache_php configuration.
** However you should not change ** `['php-fpm']['package_name']`,`['php-fpm']['service_name']` or `['php']['packages']` (as they are part of this cookbook logic) without checking it works.

## In scope

The goal of this library is to do the basic configuration to serve PHP pages through Apache. It will only configure `apache2` and the default php handler, users are free to configure their vhost if they need anything more specific.

More in details it :

* Installs and configure Apache2 web server
* Installs and configure php-fpm
* Installs and configure php
* Configures Apache2 to serve php pages through php-fpm (in conf.d)
* Gets the correct packages and change the configuration according to the php/apache version

## Out of scope

Virtual Host are not managed by this cookbook, the configuration provided by this cookbook should not prevent users to extend php or php-fpm configuration.
As many features as possible should have a flag to enable/disable them, it will allow to enjoy some parts of the work done by this cookbook (get the correct packages by example) but still be able to configure your own php-fpm pools.


### Examples
#### Apache and PHP 5.5

```
node.default['rackspace_apache_php']['php_version'] = '5.5'
include_recipe 'rackspace_apache_php::default'
```

#### Apache and PHP 5.6

```
include_recipe 'rackspace_apache_php::default'
```

#### Apache and PHP 5.6 without default PHP handler and default PHP-FPM pool

You will have to add your own Vhost to configure the handler, here is an example using a `web_app` resource and the `apache_conf` definition from the upstream apache2 cookbook to create a virtual host and the Apache configuration necessary to handle php requests (templates not provided). It also leverages the `['php-fpm']['pools']` attribute from the upstream php-fpm cookbook to create a custom defined php-fpm pool listening on a socket. Although not provided below, the templates for the `apache_conf` definition and the `web_app` resource should contain the necessary directives to pass requestes for php files to the php-fpm pool.

```
node.default['rackspace_apache_php']['php_handler']['enable'] = false
node.default['rackspace_apache_php']['php-fpm']['default_pool']['enable'] = false

# Create a php-fpm pool through the attribute exposed from upstream
node.default['php-fpm']['pools'] = {
  override: {
    enable: 'true',
    process_manager: 'dynamic',
    max_requests: 5000
  }
}

include_recipe 'rackspace_apache_php::default'

# Create your own php-handler
apache_conf 'my-php-handler' do
  source 'my-php-handler.conf.erb'
  cookbook 'my-cookbook'
  enable true
end

# Create a virtual host to serve pages
web_app "my_site" do
  server_name node['hostname']
  server_aliases [node['fqdn'], "my-site.example.com"]
  docroot "/srv/www/my_site"
  cookbook 'my-cookbook'
  php_socket '/var/run/php-fpm-override.sock'
end

```

## References

* [Apache2 cookbook](https://github.com/svanzoest-cookbooks/apache2)
* [PHP-fpm cookbook](https://github.com/yevgenko/cookbook-php-fpm)
* [PHP cookbook](https://github.com/opscode-cookbooks/php)


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Julien Berard (julien.berard@rackspace.co.uk), Kostas Georgakopoulos (kostas.georgakopoulos@rackspace.co.uk)
