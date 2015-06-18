# Encoding: utf-8
set :backend, :exec
set :path, '/sbin:/usr/local/sbin:/bin:/usr/bin:$PATH'

def test_data
  data = {
    redhat: {
      default: {
        docroot:              '/var/www/html',
        apache_service_name:  'httpd',
        fpm_service_name:     'php-fpm',
        apache2ctl:           '/usr/sbin/apachectl',
        default_pool:         '/etc/php-fpm.d/default.conf',
        fpm_socket:           '/var/run/php-fpm-default.sock'
      },
      override: {
        docroot:              '/var/www/html',
        apache_service_name:  'httpd',
        fpm_service_name:     'php-fpm',
        apache2ctl:           '/usr/sbin/apachectl',
        default_pool:         '/etc/php-fpm.d/override.conf',
        fpm_socket:           '/var/run/php-fpm-override.sock'
      }
    },
    ubuntu: {
      default: {
        docroot:              '/var/www/html',
        apache_service_name:  'apache2',
        fpm_service_name:     'php5-fpm',
        apache2ctl:           '/usr/sbin/apache2ctl',
        default_pool:         '/etc/php5/fpm/pool.d/default.conf',
        fpm_socket:           '/var/run/php-fpm-default.sock'
      },
      override: {
        docroot:              '/var/www/html',
        apache_service_name:  'apache2',
        fpm_service_name:     'php5-fpm',
        apache2ctl:           '/usr/sbin/apache2ctl',
        default_pool:         '/etc/php5/fpm/pool.d/override.conf',
        fpm_socket:           '/var/run/php-fpm-override.sock'
      }
    },
    other: {
      default: {
        docroot:              '/var/www/html',
        apache_service_name:  'apache2',
        fpm_service_name:     'php5-fpm',
        apache2ctl:           '/usr/sbin/apache2ctl',
        default_pool:         '/etc/php5/fpm/pool.d/default.conf',
        fpm_socket:           '/var/run/php-fpm-default.sock'
      },
      override: {
        docroot:              '/var/www/html',
        apache_service_name:  'apache2',
        fpm_service_name:     'php5-fpm',
        apache2ctl:           '/usr/sbin/apache2ctl',
        default_pool:         '/etc/php5/fpm/pool.d/override.conf',
        fpm_socket:           '/var/run/php-fpm-override.sock'
      }
    }
  }
  data
end

def get_test_data_value(family, suite, attribute)
  test_data[family][suite][attribute]
end

def page_returns(url = 'http://localhost:80/', host = 'localhost', ssl = false)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.read_timeout = 70
  if ssl
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  req = Net::HTTP::Get.new(uri.request_uri)
  req.initialize_http_header('Host' => host)
  http.request(req).body
end
