# tomee

This cookbook installs and configures Apache TomEE. 
It starts downloading TomEE from an tomee_url specified in attributes/default.rb.

This cookbook is a beta version inspired on Opscode's Tomcat cookbook.

## Supported Platforms

- Debian, Ubuntu (OpenJDK, Oracle)
- CentOS 6+, Red Hat 6+, Fedora

Used with: Centos (6.2, 6.5) and Ubuntu (14.04)

### Dependencies
- java
- openssl

### Quick start with Vagrant

Download and install Vagrant: https://www.vagrantup.com/downloads.html

    git clone https://github.com/freedev/vagrant-tomee.git
    cd vagrant-tomee
    vagrant up

### Quick start with chef-solo

Download chef from: https://downloads.chef.io/chef-dk/

For redhat execute:

    wget https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chefdk-0.4.0-1.x86_64.rpm
    rpm -i chefdk-0.4.0-1.x86_64.rpm

Then execute the following commands:

    mkdir ~/install-tomee
    mkdir -p /var/chef/cookbooks
    mkdir -p /var/chef/data_bags/tomee_users
    cd /var/chef/cookbooks/
    git init
    touch README.md
    git add README.md
    git commit -a -m "updates"
    cd ~/install-tomee
    knife cookbook site install tomee
    cp /var/chef/cookbooks/tomee/templates/default/tomee.json .
    cp /var/chef/cookbooks/tomee/templates/default/admin.json /var/chef/data_bags/tomee_users
    chef-solo -j tomee.json

###Prerequisites
This cookbook cames with a dependency to `java` and `openssl` cookbooks.<br>

`common-packages` recipe has been added to fix the installation of 
`java` with debian/ubuntu platforms.<br>

`java` cookbook has a dependency with `curl` package.
When `java` cookbook is executed it doesn't check for apt-get repository update, 
`curl` package installation fails because of apt-get repository not is updated yet.<br>

`common-packages` has been executed as first just to update apt-get repository before.


## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['tomee']['deploy_multiple_instances']</tt></td>
    <td>Boolean</td>
    <td>If you want deploy multiple instances within the same node, you must also fill the 'instances' attribute with the list of instances, ports, etc.</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['tomee']['name']</tt></td>
    <td>String</td>
    <td>Service name, used only for base instance</td>
    <td><tt>tomee</tt></td>
  </tr>
  <tr>
    <td><tt>['tomee']['user']</tt></td>
    <td>String</td>
    <td>User name</td>
    <td><tt>tmuser</tt></td>
  </tr>
  <tr>
    <td><tt>['tomee']['group']</tt></td>
    <td>String</td>
    <td>Group name</td>
    <td><tt>tomee</tt></td>
  </tr>
  <tr>
    <td><tt>['tomee']['tomee_url']</tt></td>
    <td>String</td>
    <td>Tomee tar gz url</td>
    <td><tt>http://my.internal.server/apache-tomee-1.7.1-plume.tar.gz</tt></td>
  </tr>
  <tr>
    <td><tt>['tomee']['port']</tt></td>
    <td>Integer</td>
    <td>HTTP port number</td>
    <td><tt>8080</tt></td>
  </tr>
  <tr>
    <td><tt>['tomee']['proxy_port']</tt></td>
    <td>Integer</td>
    <td>HTTP proxy port number</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['tomee']['ssl_port']</tt></td>
    <td>Integer</td>
    <td>HTTP port number</td>
    <td><tt>8443</tt></td>
  </tr>
  <tr>
    <td><tt>['tomee']['ssl_proxy_port']</tt></td>
    <td>Integer</td>
    <td>HTTP proxy port number</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['tomee']['ajp_port']</tt></td>
    <td>Integer</td>
    <td>ajp port number</td>
    <td><tt>8009</tt></td>
  </tr>
  <tr>
    <td><tt>['tomee']['shutdown_port']</tt></td>
    <td>Integer</td>
    <td>Shutdown port</td>
    <td><tt>8005</tt></td>
  </tr>
  <tr>
    <td><tt>['tomee']['vhost_name']</tt></td>
    <td>String</td>
    <td>Host</td>
    <td><tt>localhost</tt></td>
  </tr>
  <tr>
    <td><tt>['tomee']['aliases']</tt></td>
    <td>Array</td>
    <td>List of domain aliases mapped</td>
    <td><tt>["www.example.com", "example.com"]</tt></td>
  </tr>
</table>

## Usage

### tomee::default

Include `tomee` in your node's `run_list`, if you want install Java you must prepend `common-packages` and `java::default` :

```json
{
  "run_list": [
    "recipe[tomee::common-packages]",
    "recipe[java::default]",
    "recipe[tomee::default]"
  ]
}
```

## License and Authors

Author:: Vincenzo D'Amore (<v.damore@gmail.com>)
