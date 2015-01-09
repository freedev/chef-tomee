name             'tomee'
maintainer       "Vincenzo D'Amore"
maintainer_email "v.damore@gmail.com"
license          'Apache 2.0'
description      'Installs/Configures TomEE'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.4.0'

# depends 'apt', '~> 2.6.0'
depends 'java', '~> 1.21'
depends "openssl", ">= 0.0.0"
# depends 'maven', '~> 1.2.0'
# depends 'tomcat', '~> 0.17.0'
# depends 'net-scp', '~> 1.2.1'

supports "debian", ">= 0.0.0"
supports "ubuntu", ">= 0.0.0"
supports "centos", ">= 0.0.0"
supports "redhat", ">= 0.0.0"
supports "fedora", ">= 0.0.0"
supports "amazon", ">= 0.0.0"
