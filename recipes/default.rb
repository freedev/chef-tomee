#
# Cookbook Name:: tomee
# Recipe:: default
#
# Copyright (C) 2014 Vincenzo D'Amore v.damore@gmail.com
#
# All rights reserved - Do Not Redistribute
#

# require 'pp'

# required for the secure_password method from the openssl cookbook
::Chef::Recipe.send(:include, OpenSSLCookbook::Password)

current_node = node['tomee']

tomee_user = current_node['user']
tomee_group = current_node['group']
tomee_user_home = "/home/#{tomee_user}"

group tomee_group

user tomee_user do
  group tomee_group
  shell '/bin/bash'
  home tomee_user_home
  supports :manage_home => true
  password '$1$RF0eUP9s$r.H4rcWvQ9zc5REJydT2c/'
  action :create
end

node.set_unless['tomee']['keystore_password'] = secure_password
# node.set_unless['tomee']['truststore_password'] = secure_password

if current_node['deploy_multiple_instances'] == true
  current_node['instances'].each do |name, attrs|
  
    call_attrs = {}
    current_node.keys.each do |k_name|
      if k_name != "instances" and not attrs[k_name]
        call_attrs[k_name] = current_node[k_name]
      else
        call_attrs[k_name] = attrs[k_name]
      end  
    end 
  
    call_attrs['name'] = name
  
    call_attrs = materialize call_attrs
    call_attrs = materialize call_attrs
  
    tomee_instance name do
      node_attributes call_attrs
    end
  end
end

current_node = materialize current_node
current_node = materialize current_node

tomee_instance "tomee" do
  node_attributes current_node
  only_if { current_node['deploy_multiple_instances'] == false }
end
