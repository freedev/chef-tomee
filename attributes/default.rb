
# set deploy_multiple_instances = true if you want create multiple instances 
default["tomee"]["deploy_multiple_instances"] = false
default["tomee"]["name"]="tomee"
default["tomee"]["user"]="tmuser"
default["tomee"]["group"]="tomee"

default["tomee"]["tomee_url"] = "http://apache.fastbull.org/tomee/tomee-1.7.1/apache-tomee-1.7.1-webprofile.tar.gz"

default["tomee"]["port"] = 8080
default["tomee"]["proxy_port"] = nil
default["tomee"]["ssl_port"] = 8443
default["tomee"]["ssl_proxy_port"] = nil
default["tomee"]["ajp_port"] = 8009
default["tomee"]["shutdown_port"] = 8005
default["tomee"]["vhost_name"] = 'localhost'
default["tomee"]["vhost_aliases"] = ['example.com']

default["tomee"]["catalina_options"] = ""
default["tomee"]["java_options"] = "-Xmx128M -Djava.awt.headless=true"
default["tomee"]["use_security_manager"] = false
default["tomee"]["authbind"] = "no"
default["tomee"]["deploy_manager_apps"] = true
default["tomee"]["max_threads"] = 150
default["tomee"]["ssl_max_threads"] = 150
default["tomee"]["ssl_cert_file"] = nil
default["tomee"]["ssl_key_file"] = nil
default["tomee"]["ssl_chain_files"] = nil
default["tomee"]["keystore_file"] = "keystore.jks"
default["tomee"]["keystore_type"] = "jks"
# The keystore and truststore passwords will be generated by the
# openssl cookbook's secure_password method in the recipe if they are
# not otherwise set. Do not hardcode passwords in the cookbook.
default["tomee"]["keystore_password"] = "supersecret"
default["tomee"]["certificate_dn"] = "cn=localhost,OU=Office,O=Company,L=City,ST=State,C=IT"
# default["tomee"]["truststore_password"] = nil
# default["tomee"]["truststore_file"] = "#{node["java"]["java_home"]}/jre/lib/security/cacerts"
# default["tomee"]["truststore_type"] = "pem"
default["tomee"]["loglevel"] = "INFO"
default["tomee"]["log_handlers"]['catalina'] = "INFO"
default["tomee"]["log_handlers"]['localhost'] = "INFO"
default["tomee"]["log_handlers"]['manager'] = "INFO"
default["tomee"]["log_handlers"]['host-manager'] = "INFO"
default["tomee"]["tomcat_auth"] = "true"
default["tomee"]["instances"] = {}

default["tomee"]["home"] = "/opt/%{name}"
default["tomee"]["base"] = "/opt/%{name}"
default["tomee"]["config_dir"] = "%{base}/conf"
default["tomee"]["log_dir"] = "%{base}/logs"
default["tomee"]["tmp_dir"] = "%{base}/temp"
default["tomee"]["work_dir"] = "%{base}/work"
default["tomee"]["context_dir"] = "%{config_dir}/Catalina/localhost"
default["tomee"]["webapp_dir"] = "%{base}/webapps"
default["tomee"]["keytool"] = "keytool"
default["tomee"]["lib_dir"] = "%{home}/lib"
default["tomee"]["endorsed_dir"] = "%{lib_dir}/endorsed"
default["tomee"]["catalina_pid"] = "%{log_dir}/catalina-daemon.pid"
