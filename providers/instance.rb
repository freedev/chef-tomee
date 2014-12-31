action :configure do
  puts "called tomee_instance"

  base_instance = "tomee"

  # Set defaults for resource attributes from node attributes. We can't do
  # this in the resource declaration because node isn't populated yet when
  # that runs
  [:catalina_options, :java_options, :use_security_manager, :authbind,
   :max_threads, :ssl_max_threads, :ssl_cert_file, :ssl_key_file,
   :ssl_chain_files, :keystore_file, :keystore_type, :truststore_file,
   :truststore_type, :certificate_dn, :loglevel, :tomee_auth, :user,
   :group, :tmp_dir, :lib_dir, :endorsed_dir].each do |attr|
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
      :instance => instance
    })
    owner "#{new_resource.user}"
    group "#{new_resource.group}"
    mode '0755'
  end

  template "#{new_resource.home}/env_#{instance}.sh" do
    source 'env_tomee.sh.erb'
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
      :endorsed_dir => new_resource.endorsed_dir
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
#    notifies :restart, "service[tomcat]"
  end
  
#service "#{instance}" do
#  case node['platform']
#  when 'centos', 'redhat', 'fedora', 'amazon'
#    service_name "#{instance}"
#    supports :restart => true, :status => true
#  when 'debian', 'ubuntu'
#    service_name "#{instance}"
#    supports :restart => true, :reload => false, :status => true
#  when 'smartos'
#    # SmartOS doesn't support multiple instances
#    service_name 'tomcat'
#    supports :restart => false, :reload => false, :status => true
#  else
#    service_name "#{instance}"
#  end
#  action [:start, :enable]
#end
   
end