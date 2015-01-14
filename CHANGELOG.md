# 0.5.0

Changed default box in Vagrantfile 
`config.vm.box = 'chef/ubuntu-14.04'`

Added in Vagrantfile a forwarded port mapping which allows access to Tomee default 8080
`config.vm.network "forwarded_port", guest: 8080, host: 8080`

# 0.4.0

Fixed few Foodcritic warning

# 0.1.0

Initial release of tomee
