require 'tmpdir'
require 'uri'
require 'pp'

include Materialization

action :configure do
  
  # Set defaults for resource attributes from node attributes. We can't do
  # this in the resource declaration because node isn't populated yet when
  # that runs
#  [:catalina_options, :java_options, :use_security_manager, :authbind,
#   :max_threads, :ssl_max_threads, :ssl_cert_file, :ssl_key_file,
#   :ssl_chain_files, :keystore_file, :keystore_type, :certificate_dn, :loglevel, :tomcat_auth, :user,
#   :group, :tmp_dir, :lib_dir, :endorsed_dir, :catalina_pid, :tomee_url].each do |attr|

  instance_attributes = new_resource.node_attributes
  
  instance = new_resource.name.gsub(/^.*(\\|\/)/, '').gsub(/[^0-9A-Za-z.\-]/, '_')

  tomee_uri = URI.parse(instance_attributes['tomee_url'])
  tomee_filename = ::File.basename(tomee_uri.path)
  tomee_basename = ::File.basename(tomee_uri.path, '.tar.gz')
  tmpdir = Dir.tmpdir

  remote_file "#{tmpdir}/#{tomee_filename}" do
    source instance_attributes['tomee_url']
  end

  directory instance_attributes['home'] do
    owner instance_attributes['user']
    group instance_attributes['group']
    action :create
  end

  execute "tar-install-#{tomee_filename}" do
    user instance_attributes['user']
    group instance_attributes['group']
    command "tar xzf #{tmpdir}/#{tomee_filename} --strip 1"
    action :run
    cwd instance_attributes['home']
    returns 0
  end

  directory instance_attributes['endorsed_dir'] do
    mode '0755'
    recursive true
  end

  if instance_attributes['ssl_cert_file'].nil?

    create_tomee_ssl_certificat_command = %{
      #{instance_attributes['keytool']} \
       -genkey -keyalg RSA -keysize 2048 -trustcacerts \
       -alias #{instance} \
       -keystore \"#{instance_attributes['config_dir']}/#{instance_attributes['keystore_file']}\" \
       -storepass #{instance_attributes['keystore_password']} \
       -dname \"#{instance_attributes['certificate_dn']}"
       }
    
    execute 'Create Tomee SSL certificate' do
      group instance_attributes['group']
      command create_tomee_ssl_certificat_command
      umask 0007
      creates "#{instance_attributes['config_dir']}/#{instance_attributes['keystore_file']}"
      action :run
      notifies :restart, "service[#{instance}]"
    end
  else
    
#    ssl_chain_files = ""
#    instance_attributes['ssl_chain_files'].each do |item|
#      ssl_chain_files = ssl_chain_files + " #{instance_attributes['config_dir']}/#{item} "
#    end
#    
#    create_keystore_certificate = %{
#      cat #{ssl_chain_files} > cacerts.pem
#      openssl pkcs12 -export \
#       -inkey #{instance_attributes['ssl_key_file']} \
#       -in #{instance_attributes['ssl_cert_file']} \
#       -chain \
#       -CAfile cacerts.pem \
#       -password pass:#{instance_attributes['keystore_password']} \
#       -out #{instance_attributes['config_dir']}/#{instance_attributes['keystore_file']}
#    }

    create_tomee_ssl_import_cert_command = %{
      #{instance_attributes['keytool']} \
       -import -trustcacerts \
       -storepass #{instance_attributes['keystore_password']} \
       -keystore \"#{instance_attributes['config_dir']}/#{instance_attributes['keystore_file']}\" \
       }
    
    instance_attributes['ssl_chain_files'].each do |cert|
      cookbook_file cert do
        path "#{instance_attributes['config_dir']}/#{cert}"
        mode '0644'
      end

      execute "Create Tomee SSL import certificate #{cert}" do
        group instance_attributes['group']
        command create_tomee_ssl_import_cert_command+ %{ -alias #{cert} -file \"#{instance_attributes['config_dir']}/#{cert}\"  }
        umask 0007
        action :run
      end
    end

    cookbook_file instance_attributes['ssl_cert_file'] do
      path "#{instance_attributes['config_dir']}/#{instance_attributes['ssl_cert_file']}"
      mode '0644'
    end

    execute "Create Tomee SSL import certificate #{instance_attributes['ssl_cert_file']}" do
      group instance_attributes['group']
      command create_tomee_ssl_import_cert_command+ %{ -alias #{instance_attributes['vhost_name']} -file \"#{instance_attributes['config_dir']}/#{instance_attributes['ssl_cert_file']}\"  }
      umask 0007
      action :run
    end
  end
  
  template "/etc/init.d/#{instance}" do
    source 'service_tomee.erb'
    variables ({
      :instance => instance,
      :base => instance_attributes['base'],
      :log_dir => instance_attributes['log_dir'],
      :catalina_pid => instance_attributes['catalina_pid']
    })
    owner "root"
    group "root"
    mode '0755'
  end

  service instance do
    service_name instance
    case node['platform']
    when 'centos', 'redhat', 'fedora', 'amazon'
      provider Chef::Provider::Service::Init::Redhat
#      subscribes :restart, resources(:template => "/etc/init.d/#{instance}")
      supports :restart => true, :start => true, :stop => true
    when 'debian', 'ubuntu'
      provider Chef::Provider::Service::Init::Debian
#      subscribes :restart, resources(:template => "/etc/init.d/#{instance}")
      supports :restart => true, :start => true, :stop => true
    end
  end
       
  template "#{instance_attributes['home']}/bin/setenv.sh" do
    source 'setenv_tomee.sh.erb'
    variables ({
      :user => instance_attributes['user'],
      :group => instance_attributes['group'],
      :home => instance_attributes['home'],
      :base => instance_attributes['base'],
      :java_options => instance_attributes['java_options'],
      :use_security_manager => instance_attributes['use_security_manager'],
      :tmp_dir => instance_attributes['tmp_dir'],
      :authbind => instance_attributes['authbind'],
      :catalina_options => instance_attributes['catalina_options'],
      :endorsed_dir => instance_attributes['endorsed_dir'],
      :catalina_pid => instance_attributes['catalina_pid'],
      :remote_debug => instance_attributes['remote_debug']
    })
    owner instance_attributes['user']
    group instance_attributes['group']
    mode '0755'
#    notifies :restart, "service[#{instance}]"
  end   

  template "#{instance_attributes['config_dir']}/tomcat-users.xml" do
    source 'tomee-users.xml.erb'
    mode '0644'
    variables(
      :users => TomeeCookbook.users,
      :roles => TomeeCookbook.roles
    )
#    notifies :restart, "service[#{instance}]"
  end

  template "#{instance_attributes['config_dir']}/system.properties" do
    source 'system.properties.erb'
    mode '0644'
  end
  
  template "#{instance_attributes['config_dir']}/server.xml" do
    source 'tomee_server.xml.erb'
      variables ({
        :port => instance_attributes['port'],
        :proxy_port => instance_attributes['proxy_port'],
        :ssl_port => instance_attributes['ssl_port'],
        :ssl_proxy_port => instance_attributes['ssl_proxy_port'],
        :ajp_port => instance_attributes['ajp_port'],
        :shutdown_port => instance_attributes['shutdown_port'],
        :max_threads => instance_attributes['max_threads'],
        :vhost_name => instance_attributes['vhost_name'],
        :vhost_aliases => instance_attributes['vhost_aliases'],
        :max_threads => instance_attributes['max_threads'],
        :ssl_max_threads => instance_attributes['ssl_max_threads'],
        :ssl_cert_file => instance_attributes['ssl_cert_file'],
        :ssl_key_file => instance_attributes['ssl_key_file'],
        :keystore_file => instance_attributes['keystore_file'],
        :keystore_password => instance_attributes['keystore_password'],
        :keystore_type => instance_attributes['keystore_type'],
        :tomcat_auth => instance_attributes['tomcat_auth'],
        :config_dir => instance_attributes['config_dir'],
      })
    owner instance_attributes['user']
    group instance_attributes['group']
    mode '0644'
  end
  
  template "#{instance_attributes['config_dir']}/logging.properties" do
    source 'logging.properties.erb'
    variables ({
      :vhost_name => instance_attributes['vhost_name'],
      :loglevel => instance_attributes['loglevel'],
      :log_handlers => instance_attributes['log_handlers']
    })
    owner instance_attributes['user']
    group instance_attributes['group']
    mode '0644'
  end
    
  service instance do
    action [:restart, :enable]
#    notifies :run, "service[#{instance}]", :immediately
#    retries 4
#    retry_delay 30
  end
     
end
