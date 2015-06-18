require 'spec_helper'

describe 'apache tests' do
  it_behaves_like 'apache', :override # param denotes the suite under test
end

describe 'php-fpm tests' do
  it_behaves_like 'php-fpm', :override, :default # params denote 'enabled suite' and 'disabled suite'
end

describe 'php tests' do
  it_behaves_like 'php under apache', 5.6, :override
  it_behaves_like 'php', 5.6
end
