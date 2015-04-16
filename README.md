# rackspace_apache_php-cookbook

A cookbook to provide a web server able to serve php pages with Apache and PHP fpm.
It relies on [apache2 cookbook](https://github.com/svanzoest-cookbooks/apache2/) and [php-fpm](https://github.com/yevgenko/cookbook-php-fpm). Those cookbooks are pinned on well known working minor version to prevent breaking changes.
In addition (even if this is not a requirement), the cookbook will install php packages through [PHP cookbook](https://github.com/opscode-cookbooks/php). Indeed most of the time you will need `php::default` in your role which will conflict with the `php-fpm` package if they are different.
You can disable the installation of php packages with `node['rackspace_apache_php']['php_packages_install']['enable']`.

## Supported Platforms

* Centos 6.5
* Ubuntu 12.04
* Ubuntu 14.04 [(only PHP 5.5 and 5.6)](https://github.com/oerdnj/deb.sury.org/issues/58#issuecomment-92246112)

## Attributes

`node['rackspace_apache_php']['php_version']` : Which PHP version to install, default to PHP 5.6
`node['rackspace_apache_php']['php_handler']['enable']` : Should it enable Apache PHP handler (applied in "conf.d", so it will be available in EVERY vhost, if you want to manage your own handler configuration, set this attribute to false)
`node['rackspace_apache_php']['php_handler']['cookbook']` : Where to find the handler configuration , default to `rackspace_apache_php cookbook`
`node['rackspace_apache_php']['php_handler']['template']` : Where to find the handler configuration , default to `php-handler.conf.erb`

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
However you should not change `['php-fpm']['package_name']`,`['php-fpm']['service_name']` or `['php']['packages']` (as they are part of this cookbook logic) without checking it works.

## In scope

The goal of this library is to do the basic configuration to serve PHP pages through Apache. It will only configure `apache2` and the default php handler, users are free to configure their vhost if they need anything more specific.

More in details it : 

* Installs and configure Apache2 web server
* Installs and configure php-fpm
* Installs and configure php
* Configures Apache2 to serve php pages through php-fpm (in conf.d)
* gets the correct packages and change the configuration according to the php/apache version 

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

#### Apache and PHP 5.6 without default PHP handler

You will have to add your own Vhost to configure the handler, here is an example using a `web_app` attribute to pass php-fpm default socket.
 
```
include_recipe 'rackspace_apache_php::default'

web_app "my_site" do
  server_name node['hostname']
  server_aliases [node['fqdn'], "my-site.example.com"]
  docroot "/srv/www/my_site"
  cookbook 'mycookbook'
  php_socket '/var/run/php-fpm-www.sock'
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

Author:: Julien Berard (julien.berard@rackspace.com)
