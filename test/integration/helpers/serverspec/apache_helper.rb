shared_examples_for 'apache' do |suite|
  # Basic tests
  describe service(get_helper_data_value(suite, :apache_service_name)) do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening }
  end

  # Configuration syntax test
  describe command("#{get_helper_data_value(suite, :apache2ctl)} -t") do
    its(:exit_status) { should eq 0 }
  end

  # Test modules
  get_helper_data_value(suite, :modules).each do |mod|
    describe command("#{get_helper_data_value(suite, :apache2ctl)} -M") do
      its(:stdout) { should match(/^ #{mod}_module/) }
    end
  end

  # Test document root
  describe file(get_helper_data_value(suite, :docroot)) do
    it { should be_directory }
  end
end
