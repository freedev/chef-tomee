#
# Cookbook Name:: tomee
# Recipe:: default
#
# Copyright (C) 2014 Vincenzo D'Amore v.damore@gmail.com
#
# All rights reserved - Do Not Redistribute
#

require 'uri'

tomee_user = node['tomee']['user']
tomee_group = node['tomee']['group']
tomee_user_home = "/home/#{tomee_user}"
tomee_url = node['tomee']['tomee_url']
tomee_uri = URI.parse(tomee_url)
tomee_filename = File.basename(tomee_uri.path)
tomee_basename = File.basename(tomee_uri.path, '.tar.gz')
tmpdir = '/tmp'
tomee_homedir = node['tomee']['home']

group tomee_group

user tomee_user do
  group tomee_group
  shell '/bin/bash'
  home tomee_user_home
  supports :manage_home => true
  password '$1$RF0eUP9s$r.H4rcWvQ9zc5REJydT2c/'
  action :create
end

remote_file "#{tmpdir}/#{tomee_filename}" do
  source tomee_url
end

directory tomee_homedir do
  owner tomee_user
  group tomee_group
  action :create
end

execute "tar-install-#{tomee_filename}" do
  user tomee_user
  group tomee_group
  command "tar xzf #{tmpdir}/#{tomee_filename} --strip 1"
  action :run
  cwd tomee_homedir
  returns 0
end

if node['tomcat']['run_base_instance']
  tomee_instance "base" do
    port node['tomcat']['port']
    proxy_port node['tomcat']['proxy_port']
    ssl_port node['tomcat']['ssl_port']
    ssl_proxy_port node['tomcat']['ssl_proxy_port']
    ajp_port node['tomcat']['ajp_port']
    shutdown_port node['tomcat']['shutdown_port']
  end
end

node['tomcat']['instances'].each do |name, attrs|
  tomee_instance "#{name}" do
    port attrs['port']
    proxy_port attrs['proxy_port']
    ssl_port attrs['ssl_port']
    ssl_proxy_port attrs['ssl_proxy_port']
    ajp_port attrs['ajp_port']
    shutdown_port attrs['shutdown_port']
    config_dir attrs['config_dir']
    log_dir attrs['log_dir']
    work_dir attrs['work_dir']
    context_dir attrs['context_dir']
    webapp_dir attrs['webapp_dir']
    catalina_options attrs['catalina_options']
    java_options attrs['java_options']
    use_security_manager attrs['use_security_manager']
    authbind attrs['authbind']
    max_threads attrs['max_threads']
    ssl_max_threads attrs['ssl_max_threads']
    ssl_cert_file attrs['ssl_cert_file']
    ssl_key_file attrs['ssl_key_file']
    ssl_chain_files attrs['ssl_chain_files']
    keystore_file attrs['keystore_file']
    keystore_type attrs['keystore_type']
    truststore_file attrs['truststore_file']
    truststore_type attrs['truststore_type']
    certificate_dn attrs['certificate_dn']
    loglevel attrs['loglevel']
    tomcat_auth attrs['tomcat_auth']
    user attrs['user']
    group attrs['group']
    home attrs['home']
    base attrs['base']
    tmp_dir attrs['tmp_dir']
    lib_dir attrs['lib_dir']
    endorsed_dir attrs['endorsed_dir']
  end
end

tomee_instance "base" do
  port node['tomee']['port']
  proxy_port node['tomee']['proxy_port']
  ssl_port node['tomee']['ssl_port']
  ssl_proxy_port node['tomee']['ssl_proxy_port']
  ajp_port node['tomee']['ajp_port']
  shutdown_port node['tomee']['shutdown_port']
end

