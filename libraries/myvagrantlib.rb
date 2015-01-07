require "yaml"

class MyVagrantLib

    def initialize()
    	@required_plugins = %w( vagrant-omnibus vagrant-berkshelf )
    end 

    def check_plugins
        @required_plugins.each do |plugin|
          if Vagrant.has_plugin? plugin
            puts "vagrant plugin #{plugin} already present"
          else
#            cmd = Mixlib::ShellOut.new("vagrant plugin install #{plugin}")
#            cmd.run_command
#            cmd.error!
            system "vagrant plugin install #{plugin}"
          end
        end
    end

    def get_provider(default_config)
        provider = nil
        if !default_config.nil? and !default_config.empty?
          config = YAML.load_file default_config
          provider = config['provisioner']
          if provider.nil? or provider.empty?
            provider = nil
          else
            provider = provider.to_sym
          end
        end
        if provider.nil?
          if ARGV[1] and \
             (ARGV[1].split('=')[0] == "--provider" or ARGV[2])
            provider = (ARGV[1].split('=')[1] || ARGV[2]).to_sym
          else
            provider = (ENV['VAGRANT_DEFAULT_PROVIDER'] || :virtualbox).to_sym
            puts "provider not found defaulting to #{provider}"
          end
        end
        return provider
    end
end
