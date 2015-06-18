# Encoding: utf-8
require 'serverspec'
require 'net/http'
require 'openssl'

require 'platform_helper'
require 'apache_helper'
require 'php_fpm_helper'
require 'php_helper'

set :backend, :exec

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/bin:/bin'
  end
end
