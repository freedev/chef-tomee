path File.expand_path(File.dirname(__FILE__))
file_cache_path "/root/chef-solo"
# cookbook_path "/vagrant/berks-cookbooks"
cookbook_path "#{File.expand_path(File.dirname(__FILE__))}/berks-cookbooks"
data_bag_path "#{File.expand_path(File.dirname(__FILE__))}/data_bags"
log_level ENV['CHEF_LOG_LEVEL'] && ENV['CHEF_LOG_LEVEL'].downcase.to_sym || :info
log_location ENV['CHEF_LOG_LOCATION'] || STDOUT
verbose_logging ENV['CHEF_VERBOSE_LOGGING']
