require 'spec_helper'

describe 'apache tests' do
  it_behaves_like 'apache', :override # param denotes the suite under test
end

describe 'php-fpm tests' do
  it_behaves_like 'php-fpm', :override, :default # params denote 'enabled suite' and 'disabled suite'
end

describe 'php tests' do
  if os[:family] == 'ubuntu' && os[:release] == '14.04'
    # PHP 5.4 is not supported on Ubuntu Trusty
    it_behaves_like 'php under apache', 5.5, :override
    it_behaves_like 'php', 5.5
  else
    it_behaves_like 'php under apache', 5.4, :override
    it_behaves_like 'php', 5.4
  end
end
