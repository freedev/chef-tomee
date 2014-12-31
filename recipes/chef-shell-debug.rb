#
# Cookbook Name:: tomee
# Recipe:: default
#
# Copyright (C) 2014 Vincenzo D'Amore v.damore@gmail.com
#
# All rights reserved - Do Not Redistribute
#

require 'uri'

remote_file "/root/master" do
  source "http://github.com/opscode/chef-repo/tarball/master"
end

execute "tar-install-chef-master" do
  user "root"
  group "root"
  command "tar xzf /root/master"
  action :run
  cwd "/root"
  returns 0
end

execute "create-chef-repo" do
  user "root"
  group "root"
  command "mv opscode-chef-repo* chef-repo"
  action :run
  cwd "/root"
  returns 0
end

file "/root/master" do
  user "root"
  group "root"
  action :delete
end

directory "/root/chef-repo/cookbooks" do
  owner "root"
  group "root"
  recursive true
  action :create
end

directory "/root/chef-repo/.chef" do
  owner "root"
  group "root"
  recursive true
  action :create
end


template "/root/chef-repo/.chef/knife.rb" do
  source 'knife.rb.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :cookbook_path => "/root/chef-repo/cookbooks"
  )
end
