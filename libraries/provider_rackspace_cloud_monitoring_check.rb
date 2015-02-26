require 'chef/resource/lwrp_base'

class Chef
  class Provider
    # Provider definition for rackspace_cloud_monitoring_check
    class RackspaceCloudMonitoringCheck < Chef::Provider::LWRPBase
      include RackspaceCloudMonitoringCookbook::Helpers

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :create do
        define_rackspace_monitoring_agent_service
        # Download plugin if the parameter is set
        download_plugin if new_resource.plugin_url
        template "#{agent_conf_d}/#{new_resource.name}.yaml" do
          cookbook new_resource.cookbook
          source parsed_template_from_type
          owner 'root'
          group 'root'
          mode '00644'
          variables(parsed_template_variables('false'))
          notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
        end
      end

      action :delete do
        define_rackspace_monitoring_agent_service
        file "#{agent_conf_d}/#{new_resource.name}.yaml" do
          action :delete
          notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
        end
        delete_plugin if new_resource.type == 'agent.plugin'
      end

      action :enable do
        define_rackspace_monitoring_agent_service
        template "#{agent_conf_d}/#{new_resource.name}.yaml" do
          cookbook new_resource.cookbook
          source parsed_template_from_type
          owner 'root'
          group 'root'
          mode '00644'
          variables(parsed_template_variables('false'))
          notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
        end
      end

      action :disable do
        define_rackspace_monitoring_agent_service
        template "#{agent_conf_d}/#{new_resource.name}.yaml" do
          cookbook new_resource.cookbook
          source parsed_template_from_type
          owner 'root'
          group 'root'
          mode '00644'
          variables(parsed_template_variables('true'))
          notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
        end
      end

      def define_rackspace_monitoring_agent_service
        # FIXME
        # Workaround as "service 'rackspace-monitoring-agent'" (defined in provider_rackspace_cloud_monitoring_service) is not available
        service 'rackspace-monitoring-agent' do
          supports start: true, status: true, stop: true, restart: true
          action :nothing
        end
      end

      def download_plugin
        directory plugin_path do
          action :create
          recursive true
        end
        Chef::Log.info("Downloading plugin from #{new_resource.plugin_url} to #{plugin_path}/#{parsed_plugin_filename}")
        remote_file "#{plugin_path}/#{parsed_plugin_filename}" do
          source new_resource.plugin_url
        end
      end

      def delete_plugin
        Chef::Log.info("Deleting plugin #{plugin_path}/#{parsed_plugin_filename}")
        file "#{plugin_path}/#{parsed_plugin_filename}" do
          action :delete
          notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
        end
      end
    end
  end
end
