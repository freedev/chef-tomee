# -*- mode: ruby -*-
# vi: set ft=ruby :

current_dir = File.dirname(__FILE__)

require 'yaml'
require_relative "libraries/myvagrantlib.rb"

mylib = MyVagrantLib.new

mylib.check_plugins

provider = mylib.get_provider("#{current_dir}/config/provisioner.yml")

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.require_version '>= 1.5.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = 'tomee-berkshelf'

  # Set the version of chef to install using the vagrant-omnibus plugin
  # NOTE: You will need to install the vagrant-omnibus plugin:
  #
  #   $ vagrant plugin install vagrant-omnibus
  #
  if Vagrant.has_plugin? 'vagrant-omnibus'
    config.omnibus.chef_version = 'latest'
  end

  # Every Vagrant virtual environment requires a box to build off of.
  # If this value is a shorthand to a box in Vagrant Cloud then
  # config.vm.box_url doesn't need to be specified.

  if provider == :virtualbox
    puts "* Using virtualbox *"
#    config.vm.box = 'freedev/centos-6.2-x86_64'
    config.vm.box = 'chef/ubuntu-14.04'
#    config.vm.box = 'opscode-centos-6.5'
#    config.vm.synced_folder ".", "/vagrant", type: "nfs"

    vb_conf={}
    vb_conf['vb_cpu_count'] = "2"
    # vb_conf['vb_cpu_exec_cap']="xx"
    vb_conf['vb_memory'] = "2048"
    vb_conf['vb_name'] = "Vagrant Apache Tomee"
    vb_conf['vb_vram'] = "12"

    config.vm.provider :virtualbox do |vb|

      vb.customize ["modifyvm", :id, "--cpus", vb_conf['vb_cpu_count']]
#      vb.customize ["modifyvm", :id, "--cpuexecutioncap", vb_conf['vb_cpu_exec_cap']]
      vb.customize ["modifyvm", :id, "--memory", vb_conf['vb_memory']]
      vb.customize ["modifyvm", :id, "--name", vb_conf['vb_name']]
      vb.customize ["modifyvm", :id, "--vram", vb_conf['vb_vram']]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
#      vb.customize ["modifyvm", :id, "--snapshotfolder", "default"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]

    end 
  end



  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, type: 'dhcp'

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  
  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.



# $provision_script= <<SCRIPT
#   sudo add-apt-repository -y ppa:webupd8team/java
#   sudo apt-get update
#   sudo apt-get -y install puppet
#   echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
#   sudo apt-get -y install oracle-java8-installer
# SCRIPT
# 
#   config.vm.provision :shell, :inline => $provision_script


  # The path to the Berksfile to use with Vagrant Berkshelf
  config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  config.vm.provision :chef_solo do |chef|

    chef.data_bags_path = "#{current_dir}/data_bags"

    chef.json = {
      :java => {
        :install_flavor => 'oracle',
        :jdk_version => 8,
#       :url => "http://my.internal.host/jdk-8u25-linux-x64.tar.gz",
        :oracle => {
          :accept_oracle_download_terms => true
        }
      }
#      ,:tomee => {
#        :deploy_multiple_instances => true,
#        :instances => {
#          "tomee1" => {
#            :port => 8080,
#            :ssl_port => 8443
#            :ajp_port => 8009
#            :shutdown_port => 8005
#          },
#          "tomee2" => {
#            :port => 9080,
#            :ssl_port => 9443
#            :ajp_port => 9009
#            :shutdown_port => 9005
#          }
#        }
#      }
    }

    chef.run_list = [
      'recipe[tomee::common-packages]',
      'recipe[java::default]',
      'recipe[tomee::tomee]'
    ]
  end
end
