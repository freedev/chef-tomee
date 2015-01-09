require 'tmpdir'

action :configure do

  base_instance = node['tomee']['name']

  # Set defaults for resource attributes from node attributes. We can't do
  # this in the resource declaration because node isn't populated yet when
  # that runs
#  [:catalina_options, :java_options, :use_security_manager, :authbind,
#   :max_threads, :ssl_max_threads, :ssl_cert_file, :ssl_key_file,
#   :ssl_chain_files, :keystore_file, :keystore_type, :truststore_file,
#   :truststore_type, :certificate_dn, :loglevel, :tomcat_auth, :user,
#   :group, :tmp_dir, :lib_dir, :endorsed_dir, :catalina_pid, :tomee_url].each do |attr|
  node['tomee'].keys.each do |attr|
    if not new_resource.instance_variable_get("@#{attr}")
      new_resource.instance_variable_set("@#{attr}", node['tomee'][attr])
    end
  end 

  if new_resource.name == 'base'
    instance = base_instance
  else
    instance = new_resource.name.gsub(/^.*(\\|\/)/, '').gsub(/[^0-9A-Za-z.\-]/, '_')
  end  

  if instance != base_instance
    [:base, :home, :config_dir, :log_dir, :tmp_dir, :work_dir, :context_dir,
     :webapp_dir, :lib_dir, :endorsed_dir, :catalina_pid].each do |attr|
      if node["tomee"][attr]
        new = node["tomee"][attr].sub(/\/tomee(\/|$)/, "/#{instance}\\1")
        new_resource.instance_variable_set("@#{attr}", new)
      end
    end
  end

  tomee_uri = URI.parse(new_resource.tomee_url)
  tomee_filename = ::File.basename(tomee_uri.path)
  tomee_basename = ::File.basename(tomee_uri.path, '.tar.gz')
  tmpdir = Dir.tmpdir

  remote_file "#{tmpdir}/#{tomee_filename}" do
    source new_resource.tomee_url
  end

  directory new_resource.home do
    owner new_resource.user
    group new_resource.group
    action :create
  end

  execute "tar-install-#{tomee_filename}" do
    user new_resource.user
    group new_resource.group
    command "tar xzf #{tmpdir}/#{tomee_filename} --strip 1"
    action :run
    cwd new_resource.home
    returns 0
  end

  directory new_resource.endorsed_dir do
    mode '0755'
    recursive true
  end

  unless new_resource.truststore_file.nil?
    jo = new_resource.java_options.to_s
    jo << " -Djavax.net.ssl.trustStore=$JAVA_HOME#{new_resource.truststore_file}"
    jo << " -Djavax.net.ssl.trustStorePassword=#{new_resource.truststore_password}"
    new_resource.instance_variable_set("@java_options", jo)
  end

  if new_resource.ssl_cert_file.nil?
    execute 'Create Tomee SSL certificate' do
      group new_resource.group
      command <<-EOH
        #{node['tomee']['keytool']} \
         -genkey \
         -keystore "#{new_resource.config_dir}/#{new_resource.keystore_file}" \
         -storepass "#{node['tomee']['keystore_password']}" \
         -keypass "#{node['tomee']['keystore_password']}" \
         -dname "#{node['tomee']['certificate_dn']}"
      EOH
      umask 0007
      creates "#{new_resource.config_dir}/#{new_resource.keystore_file}"
      action :run
      notifies :restart, "service[#{instance}]"
    end
  else
    script "create_keystore-#{instance}" do
      interpreter 'bash'
      action :nothing
      cwd new_resource.config_dir
      code <<-EOH
        cat #{new_resource.ssl_chain_files.join(' ')} > cacerts.pem
        openssl pkcs12 -export \
         -inkey #{new_resource.ssl_key_file} \
         -in #{new_resource.ssl_cert_file} \
         -chain \
         -CAfile cacerts.pem \
         -password pass:#{node['tomcat']['keystore_password']} \
         -out #{new_resource.keystore_file}
      EOH
      notifies :restart, "service[tomcat]"
    end
  
    cookbook_file "#{new_resource.config_dir}/#{new_resource.ssl_cert_file}" do
      mode '0644'
      notifies :run, "script[create_keystore-#{instance}]"
    end
  
    cookbook_file "#{new_resource.config_dir}/#{new_resource.ssl_key_file}" do
      mode '0644'
      notifies :run, "script[create_keystore-#{instance}]"
    end
  
    new_resource.ssl_chain_files.each do |cert|
      cookbook_file "#{new_resource.config_dir}/#{cert}" do
        mode '0644'
        notifies :run, "script[create_keystore-#{instance}]"
      end
    end
  end
  
#  unless new_resource.truststore_file.nil?
#    cookbook_file new_resource.truststore_file do
#      mode '0644'
#    end
#  end
  
  template "/etc/init.d/#{instance}" do
    source 'service_tomee.erb'
    variables ({
      :instance => instance,
      :base => new_resource.base,
      :log_dir => new_resource.log_dir,
      :catalina_pid => new_resource.catalina_pid
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
       
  template "#{new_resource.home}/bin/setenv.sh" do
    source 'setenv_tomee.sh.erb'
    variables ({
      :user => new_resource.user,
      :group => new_resource.group,
      :home => new_resource.home,
      :base => new_resource.base,
      :java_options => new_resource.java_options,
      :use_security_manager => new_resource.use_security_manager,
      :tmp_dir => new_resource.tmp_dir,
      :authbind => new_resource.authbind,
      :catalina_options => new_resource.catalina_options,
      :endorsed_dir => new_resource.endorsed_dir,
      :catalina_pid => new_resource.catalina_pid
    })
    owner new_resource.user
    group new_resource.group
    mode '0755'
#    notifies :restart, "service[#{instance}]"
  end   

  template "#{new_resource.config_dir}/tomcat-users.xml" do
    source 'tomee-users.xml.erb'
    mode '0644'
    variables(
      :users => TomeeCookbook.users,
      :roles => TomeeCookbook.roles
    )
#    notifies :restart, "service[#{instance}]"
  end

  template "#{new_resource.config_dir}/server.xml" do
    source 'tomee_server.xml.erb'
      variables ({
        :port => new_resource.port,
        :proxy_port => new_resource.proxy_port,
        :ssl_port => new_resource.ssl_port,
        :ssl_proxy_port => new_resource.ssl_proxy_port,
        :ajp_port => new_resource.ajp_port,
        :shutdown_port => new_resource.shutdown_port,
        :max_threads => new_resource.max_threads,
        :ssl_max_threads => new_resource.ssl_max_threads,
        :keystore_file => new_resource.keystore_file,
        :keystore_type => new_resource.keystore_type,
        :tomcat_auth => new_resource.tomcat_auth,
        :config_dir => new_resource.config_dir,
      })
    owner new_resource.user
    group new_resource.group
    mode '0644'
  end
  
  template "#{new_resource.config_dir}/logging.properties" do
    source 'logging.properties.erb'
    owner new_resource.user
    group new_resource.group
    mode '0644'
  end
    
  service instance do
    action [:restart, :enable]
#    notifies :run, "service[#{instance}]", :immediately
#    retries 4
#    retry_delay 30
  end
     
end
