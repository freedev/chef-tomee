actions :configure
default_action :configure

attribute :name,
  :kind_of => String,
  :required => true,
  :name_attribute => true
attribute :node_attributes,
  :kind_of => Hash

#attribute :port,
#  :kind_of => Fixnum
#attribute :proxy_port,
#  :kind_of => Fixnum
#attribute :ssl_port,
#  :kind_of => Fixnum
#attribute :ssl_proxy_port,
#  :kind_of => Fixnum
#attribute :ajp_port,
#  :kind_of => Fixnum
#attribute :shutdown_port,
#  :kind_of => Fixnum,
#  :required => true
#attribute :vhost_name,
#  :kind_of => String
#attribute :vhost_aliases,
#  :kind_of => Array
#
## The rest will inherit from node attributes
#attribute :config_dir,
#  :kind_of => String
#attribute :log_dir,
#  :kind_of => String
#attribute :work_dir,
#  :kind_of => String
#attribute :context_dir,
#  :kind_of => String
#attribute :webapp_dir,
#  :kind_of => String
#
#attribute :catalina_options,
#  :kind_of => String
#attribute :java_options,
#  :kind_of => String
#attribute :use_security_manager,
#  :kind_of => [ TrueClass, FalseClass ]
#attribute :authbind,
#  :kind_of => String,
#  :equal_to => ['yes', 'no']
#attribute :max_threads,
#  :kind_of => Fixnum
#attribute :ssl_max_threads,
#  :kind_of => Fixnum
#attribute :ssl_cert_file,
#  :kind_of => String
#attribute :ssl_key_file,
#  :kind_of => String
#attribute :ssl_chain_files,
#  :kind_of => Array
#attribute :keystore_file,
#  :kind_of => String
#attribute :keystore_password,
#:kind_of => String
#attribute :keystore_type,
#  :kind_of => String,
#  :equal_to => ['jks', 'pkcs11', 'pkcs12']
#attribute :truststore_file,
#  :kind_of => String
#attribute :truststore_type,
#  :kind_of => String,
#  :equal_to => ['jks', 'pkcs11', 'pkcs12']
#attribute :truststore_password,
#  :kind_of => String
#attribute :certificate_dn,
#  :kind_of => String
#attribute :loglevel,
#  :kind_of => String
#attribute :log_handlers,
#  :kind_of => Hash
#attribute :tomcat_auth,
#  :kind_of => String,
#  :equal_to => ['true', 'false']
#
#attribute :user,
#  :kind_of => String
#attribute :group,
#  :kind_of => String
#attribute :home,
#  :kind_of => String
#attribute :base,
#  :kind_of => String
#attribute :tmp_dir,
#  :kind_of => String
#attribute :lib_dir,
#  :kind_of => String
#attribute :endorsed_dir,
#  :kind_of => String
#attribute :catalina_pid,
#  :kind_of => String
#attribute :tomee_url,
#  :kind_of => String
    