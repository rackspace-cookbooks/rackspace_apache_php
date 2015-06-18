rackspace_apache_php CHANGELOG
==================

0.1.0
-----
- Added feature to enable/disable a default php-fpm pool
- Disabled the default pool created by upstream php-fpm cookbook
- Added testing for an 'override' recipe
- Added 'supports' statements in metadata
- Various improvements in unit and integration tests
- Changed supported Centos from 6.5 to 6.6 in README

0.0.4
-----
- Pinned upstream apache2, php and php-fpm cookbooks to minor versions with '='
- Enabled the default vhost from upstream apache2 only for integration tests

0.0.3
-----
- Removed unneeded 'libraries' directory

0.0.2
-----
- Added support for PHP in addition of PHP-fpm

0.0.1
-----
- First version
