#
# Cookbook Name:: tomee
# Recipe:: common-packages
#
# Copyright (C) 2014 Vincenzo D'Amore
#
# All rights reserved - Do Not Redistribute
#


case node['platform']
when 'centos', 'redhat', 'fedora', 'amazon'
  # yum check-update
  execute "yum-check-update" do
    command "yum check-update"
    action :run
    returns [0, 100]
  end
  
when 'debian', 'ubuntu'
  # apt-get-update
  execute "apt-get-update" do
    command "apt-get update"
    action :run
    # tip: to suppress this running every time, just use the apt cookbook
    not_if do
      ::File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
      ::File.mtime('/var/lib/apt/periodic/update-success-stamp') > Time.now - 86400*2
    end
  end

end

# java cookbook needs curl to download jdk from oracle
# package "curl"

# I like git
# package "git"

# and vim too
# package "vim"

#
#package "nfs-kernel-server"

