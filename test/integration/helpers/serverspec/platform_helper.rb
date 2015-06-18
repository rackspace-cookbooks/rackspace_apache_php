# Encoding: utf-8
set :backend, :exec
set :path, '/sbin:/usr/local/sbin:/bin:/usr/bin:$PATH'

def test_data
  # Define the data we need to test every suite per platform and release
  # An attribute specific to a release but different across suites should go into >Family>Release>Suite>Attribute
  # An attribute specific to a release but common across suites should go into >Family>Release>Common>Attribute
  # An attribute common across releases but different across suites should go into >Family>Common>Suite>Attribute
  # An attribute common across releases and suites should go into >Family>Common>Attribute
  # An attribute common across releases, suites and platforms should go into >Common>Attribute

  data = {
    redhat: {
      '6.6' => {
        default: {
          default_pool:         '/etc/php-fpm.d/default.conf',
          fpm_socket:           '/var/run/php-fpm-default.sock'
        },
        override: {
          default_pool:         '/etc/php-fpm.d/override.conf',
          fpm_socket:           '/var/run/php-fpm-override.sock'
        },
        common: {}
      },
      common: {
        docroot:                '/var/www/html',
        apache_service_name:    'httpd',
        fpm_service_name:       'php-fpm',
        apache2ctl:             '/usr/sbin/apachectl',
        default: {},
        override: {}
      }
    },
    ubuntu: {
      '12.04' => {
        default: {},
        override: {},
        common: {
          docroot:              '/var/www'
        }
      },
      '14.04' => {
        default: {},
        override: {},
        common: {
          docroot:              '/var/www/html'
        }
      },
      common: {
        apache_service_name:    'apache2',
        fpm_service_name:       'php5-fpm',
        apache2ctl:             '/usr/sbin/apache2ctl',
        default: {
          default_pool:         '/etc/php5/fpm/pool.d/default.conf',
          fpm_socket:           '/var/run/php-fpm-default.sock'
        },
        override: {
          default_pool:         '/etc/php5/fpm/pool.d/override.conf',
          fpm_socket:           '/var/run/php-fpm-override.sock'
        }
      }
    },
    common: {}
  }
  data
end

def get_test_data_value(suite, attribute)
  # Return the attribute requested for this suite from most specific to less specific

  # >Family>Release>Suite>Attribute
  return test_data[os[:family].to_sym][os[:release]][suite][attribute] unless test_data[os[:family].to_sym][os[:release]][suite][attribute].nil?
  # >Family>Release>Common>Attribute
  return test_data[os[:family].to_sym][os[:release]][:common][attribute] unless test_data[os[:family].to_sym][os[:release]][:common][attribute].nil?
  # >Family>Common>Suite>Attribute
  return test_data[os[:family].to_sym][:common][suite][attribute] unless test_data[os[:family].to_sym][:common][suite][attribute].nil?
  # >Family>Common>Attribute
  return test_data[os[:family].to_sym][:common][attribute] unless test_data[os[:family].to_sym][:common][attribute].nil?
  # >Common>Attribute
  return test_data[:common][attribute] unless test_data[:common][attribute].nil?
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
