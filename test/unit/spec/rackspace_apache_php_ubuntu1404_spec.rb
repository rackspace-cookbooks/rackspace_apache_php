require_relative 'spec_helper'

describe 'rackspace_apache_php_test::default on Ubuntu 14.04' do
  before do
    stub_resources
  end

  UBUNTU1404_SERVICE_OPTS = {
    log_level: LOG_LEVEL,
    platform: 'ubuntu',
    version: '14.04'
  }

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(UBUNTU1404_SERVICE_OPTS) do |node|
      node_resources(node)
    end.converge('rackspace_apache_php_test::default')
  end

  context 'Apache 2.2' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(UBUNTU1404_SERVICE_OPTS) do |node|
        node.set['apache']['version'] = '2.2'
      end.converge('rackspace_apache_php_test::default')
    end
    it_behaves_like 'Apache2'
    it_behaves_like 'Apache2 PHP handler', 'ubuntu', '2.2'
    it_behaves_like 'PHP-FPM'
  end
  context 'Apache 2.4' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(UBUNTU1404_SERVICE_OPTS) do |node|
        node.set['apache']['version'] = '2.4'
      end.converge('rackspace_apache_php_test::default')
    end
    it_behaves_like 'Apache2'
    it_behaves_like 'Apache2 PHP handler', 'ubuntu', '2.4'
    it_behaves_like 'PHP-FPM'
  end
end
