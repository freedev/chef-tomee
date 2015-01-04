action :configure do

  base_instance = "tomee"

  # Set defaults for resource attributes from node attributes. We can't do
  # this in the resource declaration because node isn't populated yet when
  # that runs
  [:catalina_options, :java_options, :use_security_manager, :authbind,
   :max_threads, :ssl_max_threads, :ssl_cert_file, :ssl_key_file,
   :ssl_chain_files, :keystore_file, :keystore_type, :truststore_file,
   :truststore_type, :certificate_dn, :loglevel, :tomee_auth, :user,
   :group, :tmp_dir, :lib_dir, :endorsed_dir, :jsvc].each do |attr|
    if not new_resource.instance_variable_get("@#{attr}")
      new_resource.instance_variable_set("@#{attr}", node['tomee'][attr])
    end
  end 

  instance = base_instance
  
  # If they weren't set explicitly, set these paths to the default
  [:base, :home, :config_dir, :log_dir, :work_dir, :context_dir,
   :webapp_dir].each do |attr|
    if not new_resource.instance_variable_get("@#{attr}")
      new_resource.instance_variable_set("@#{attr}", node["tomee"][attr])
    end
  end

  directory new_resource.endorsed_dir do
    mode '0755'
    recursive true
  end

  template "/etc/init.d/#{instance}" do
    source 'service_tomee.erb'
    variables ({
      :instance => instance,
      :log_dir => new_resource.log_dir
    })
    owner "#{new_resource.user}"
    group "#{new_resource.group}"
    mode '0755'
  end

  service "#{instance}" do
    service_name instance
    case node['platform']
    when 'centos', 'redhat', 'fedora', 'amazon'
      provider Chef::Provider::Service::Init::Redhat
      subscribes :restart, resources(:template => "/etc/init.d/#{instance}")
      supports :restart => true, :start => true, :stop => true
    when 'debian', 'ubuntu'
      provider Chef::Provider::Service::Init::Debian
      subscribes :restart, resources(:template => "/etc/init.d/#{instance}")
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
      :jsvc => new_resource.jsvc
    })
    owner "#{new_resource.user}"
    group "#{new_resource.group}"
    mode '0755'
#    notifies :restart, "service[#{instance}]"
  end   

  template "#{node["tomee"]["config_dir"]}/tomcat-users.xml" do
    source 'tomee-users.xml.erb'
    mode '0644'
    variables(
      :users => TomeeCookbook.users,
      :roles => TomeeCookbook.roles
    )
#    notifies :restart, "service[#{instance}]"
  end
  
  service "#{instance}" do
    action [:restart, :enable]
#    notifies :run, "service[#{instance}]", :immediately
#    retries 4
#    retry_delay 30
  end
     
end