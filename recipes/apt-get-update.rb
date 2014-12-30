#
# Cookbook Name:: hadoop-hue-hive
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "apt-get-update" do
  user "root"
  command "apt-get -y update"
  returns 0
end
