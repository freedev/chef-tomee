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
tomee_url = node['tomee']['tomee_plume_url']
tomee_uri = URI.parse(tomee_url)
tomee_filename = File.basename(tomee_uri.path)
tomee_basename = File.basename(tomee_uri.path, '.tar.gz')
basedir = '/opt'
tmpdir = '/tmp'
tomee_basedir = "#{basedir}/#{tomee_basename}"

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

directory tomee_basedir do
  owner tomee_user
  group tomee_group
  action :create
end

execute "tar-install-#{tomee_filename}" do
  user tomee_user
  group tomee_group
  command "tar xzf #{tmpdir}/#{tomee_filename} --strip 1"
  action :run
  cwd tomee_basedir
  returns 0
end

