module RackspaceCloudMonitoringCookbook
  # Helpers for the providers
  module Helpers
    include Chef::DSL::IncludeRecipe

    def agent_conf_d
      '/etc/rackspace-monitoring-agent.conf.d'
    end

    def plugin_path
      '/usr/lib/rackspace-monitoring-agent/plugins'
    end

    def configure_package_repositories
      if %w(rhel fedora).include? node['platform_family']
        yum_repository 'monitoring' do
          description 'Rackspace Cloud Monitoring agent repo'
          baseurl "https://stable.packages.cloudmonitoring.rackspace.com/#{node['platform']}-#{node['platform_version'][0]}-x86_64"
          gpgkey "https://monitoring.api.rackspacecloud.com/pki/agent/#{node['platform']}-#{node['platform_version'][0]}.asc"
          enabled true
          gpgcheck true
          action :add
        end
      else
        apt_repository 'monitoring' do
          uri "https://stable.packages.cloudmonitoring.rackspace.com/#{node['platform']}-#{node['lsb']['release']}-x86_64"
          distribution 'cloudmonitoring'
          components ['main']
          key 'https://monitoring.api.rackspacecloud.com/pki/agent/linux.asc'
          action :add
        end
      end
    end

    def parsed_cloud_credentials_username
      return new_resource.cloud_credentials_username if new_resource.cloud_credentials_username
      fail 'Cloud credential username missing, cannot setup cloud-monitoring (please set :cloud_credentials_username)'
    end

    def parsed_cloud_credentials_api_key
      return new_resource.cloud_credentials_api_key if new_resource.cloud_credentials_api_key
      fail 'Cloud credential api_key missing, cannot setup cloud-monitoring (please set :cloud_credentials_api_key)'
    end

    def parsed_target_hostname
      return new_resource.target_hostname if new_resource.target_hostname
      node['cloud']['public_ipv4']
    end

    def parsed_target
      return new_resource.target if new_resource.target
      fail "You must define a :target for #{new_resource.type}" if %( agent.disk agent.filesystem agent.network ).include?(new_resource.type)
    end

    def parsed_send_warning
      return new_resource.send_warning if new_resource.send_warning
      fail "You must define :send_warning for #{new_resource.type} if you enabled alarm" if new_resource.type == 'agent.network' && new_resource.alarm
    end

    def parsed_send_critical
      return new_resource.send_critical if new_resource.send_critical
      fail "You must define :send_critical for #{new_resource.type} if you enabled alarm" if new_resource.type == 'agent.network' && new_resource.alarm
    end

    def parsed_recv_warning
      return new_resource.recv_warning if new_resource.recv_warning
      fail "You must define :recv_warning for #{new_resource.type} if you enabled alarm" if new_resource.type == 'agent.network' && new_resource.alarm
    end

    def parsed_recv_critical
      return new_resource.recv_critical if new_resource.recv_critical
      fail "You must define :recv_critical for #{new_resource.type} if you enabled alarm" if new_resource.type == 'agent.network' && new_resource.alarm
    end

    # Get filename from URI if not defined
    def parsed_plugin_filename
      return new_resource.plugin_filename if new_resource.plugin_filename
      if new_resource.plugin_url && new_resource.type == 'agent.plugin'
        File.basename(URI(new_resource.plugin_url).request_uri)
      elsif new_resource.type == 'agent.plugin'
        fail "You must specify at least a :plugin_filename for #{new_resource.name}"
      end
    end

    # rubocop:disable MethodLength
    # FIXME: improve this (store default alarm criteria in a file?)
    def parsed_alarm_criteria
      return new_resource.alarm_criteria if new_resource.alarm_criteria
      case new_resource.type
      when 'agent.memory'
        "if (percentage(metric['actual_used'], metric['total']) > #{new_resource.critical} ) {
            return new AlarmStatus(CRITICAL, 'Memory usage is above your critical threshold of #{new_resource.critical}%');
          }
          if (percentage(metric['actual_used'], metric['total']) > #{new_resource.warning} ) {
            return new AlarmStatus(WARNING, 'Memory usage is above your warning threshold of #{new_resource.warning}%');
          }
          return new AlarmStatus(OK, 'Memory usage is below your warning threshold of #{new_resource.warning}%');
        "
      when 'agent.disk'
        "if (percentage(metric['used'], metric['total']) > #{new_resource.critical} ) {
            return new AlarmStatus(CRITICAL, 'Disk usage is above your critical threshold of #{new_resource.critical}%');
          }
          if (percentage(metric['used'], metric['total']) > #{new_resource.warning} ) {
            return new AlarmStatus(WARNING, 'Disk usage is above your warning threshold of #{new_resource.warning}%');
          }
          return new AlarmStatus(OK, 'Disk usage is below your warning threshold of #{new_resource.warning}%');
        "
      when 'agent.cpu'
        "if (metric['usage_average'] > #{new_resource.critical} ) {
            return new AlarmStatus(CRITICAL, 'CPU usage is \#{usage_average}%, above your critical threshold of #{new_resource.critical}%');
          }
          if (metric['usage_average'] > #{new_resource.warning} ) {
            return new AlarmStatus(WARNING, 'CPU usage is \#{usage_average}%, above your warning threshold of #{new_resource.warning}%');
          }
          return new AlarmStatus(OK, 'CPU usage is \#{usage_average}%, below your warning threshold of #{new_resource.warning}%');
       "
      when 'agent.load'
        "if (metric['5m'] > #{new_resource.critical} ) {
            return new AlarmStatus(CRITICAL, '5 minute load average is \#{5m}, above your critical threshold of #{new_resource.critical}');
          }
          if (metric['5m'] > #{new_resource.warning} ) {
            return new AlarmStatus(WARNING, '5 minute load average is \#{5m}, above your warning threshold of #{new_resource.warning}');
          }
          return new AlarmStatus(OK, '5 minute load average is \#{5m}, below your warning threshold of #{new_resource.warning}');
        "
      when 'agent.filesystem'
        "if (percentage(metric['used'], metric['total']) > #{new_resource.critical} ) {
              return new AlarmStatus(CRITICAL, 'Disk usage is above #{new_resource.critical}%, \#{used} out of \#{total}');
          }
          if (percentage(metric['used'], metric['total']) > #{new_resource.warning} ) {
              return new AlarmStatus(WARNING, 'Disk usage is above #{new_resource.warning}%, \#{used} out of \#{total}');
          }
          return new AlarmStatus(OK, 'Disk usage is below your warning threshold of #{new_resource.warning}%, \#{used} out of \#{total}');
        "
      when 'agent.network'
        {
          'recv' =>
            "if (rate(metric['rx_bytes']) > #{parsed_recv_critical} ) {
            return new AlarmStatus(CRITICAL, 'Network receive rate on #{parsed_target} is above your critical threshold of #{parsed_recv_critical}B/s');
          }
          if (rate(metric['rx_bytes']) > #{parsed_recv_warning} ) {
            return new AlarmStatus(WARNING, 'Network receive rate on #{parsed_target} is above your warning threshold of #{parsed_recv_warning}B/s');
          }
          return new AlarmStatus(OK, 'Network receive rate on #{parsed_target} is below your warning threshold of #{parsed_recv_warning}B/s');",
          'send' =>
            "if (rate(metric['tx_bytes']) > #{parsed_send_critical}) {
            return new AlarmStatus(CRITICAL, 'Network transmit rate on #{parsed_target} is above your critical threshold of #{parsed_send_critical}B/s');
          }
          if (rate(metric['tx_bytes']) > #{parsed_send_warning}) {
            return new AlarmStatus(WARNING, 'Network transmit rate on #{parsed_target} is above your warning threshold of #{parsed_send_warning}B/s');
          }
          return new AlarmStatus(OK, 'Network transmit rate on #{parsed_target} is below your warning threshold of #{parsed_send_warning}B/s');"
        }
      when 'remote.http'
        "if (metric['code'] regex '4[0-9][0-9]') {
           return new AlarmStatus(CRITICAL, 'HTTP server responding with 4xx status');
         }
         if (metric['code'] regex '5[0-9][0-9]') {
           return new AlarmStatus(CRITICAL, 'HTTP server responding with 5xx status');
         }
         return new AlarmStatus(OK, 'HTTP server is functioning normally');
        "
      end
    end
    # rubocop:enable MethodLength

    def parsed_template_from_type
      return new_resource.template if new_resource.template
      if %w( agent.memory agent.cpu agent.load agent.filesystem agent.disk agent.network remote.http agent.plugin).include?(new_resource.type)
        "#{new_resource.type}.conf.erb"
      else
        Chef::Log.info("Using custom monitor for #{new_resource.type}")
        'agent.custom.conf.erb'
      end
    end

    def parsed_template_variables(disabled)
      {
        cookbook: new_resource.cookbook,
        disabled: disabled,
        type: new_resource.type,
        alarm: new_resource.alarm,
        alarm_criteria: parsed_alarm_criteria,
        period: new_resource.period,
        timeout: new_resource.timeout,
        critical: new_resource.critical,
        warning: new_resource.warning,
        notification_plan_id: new_resource.notification_plan_id,
        target: parsed_target,
        target_hostname: parsed_target_hostname,
        send_warning: parsed_send_warning,
        send_critical: parsed_send_critical,
        recv_warning: parsed_recv_warning,
        recv_critical: parsed_recv_critical,
        plugin_filename: parsed_plugin_filename,
        # Using inspect so it dumps a string representing an array
        plugin_args: new_resource.plugin_args.inspect,
        plugin_timeout: new_resource.plugin_timeout,
        variables: new_resource.variables
      }
    end
  end
end
