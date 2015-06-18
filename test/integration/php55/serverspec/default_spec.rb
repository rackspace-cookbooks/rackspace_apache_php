require 'spec_helper'

describe 'apache tests' do
  it_behaves_like 'apache', :default # param denotes the suite under test
end

describe 'php-fpm tests' do
  it_behaves_like 'php-fpm', :default, :override # params denote 'enabled suite' and 'disabled suite'
end

describe 'php tests' do
  it_behaves_like 'php under apache', 5.5, :default
  it_behaves_like 'php', 5.5
end
