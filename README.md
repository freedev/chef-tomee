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

###Prerequisites
This cookbook cames with a dependency to java cookbook.
At end of document there is `run_list` 
Please make sure that Java has been configured on the machine
prior to the application any resources or recipes shipped in this
cookbook.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['tomee']['run_base_instance']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
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
</table>

## Usage

### tomee::tomee

Include `tomee` in your node's `run_list`, if you want install Java you must prepend `common-packages` and `java::default` :

```json
{
  "run_list": [
    "recipe[tomee::common-packages]",
    "recipe[java::default]",
    "recipe[tomee::tomee]"
  ]
}
```

## License and Authors

Author:: Vincenzo D'Amore (<v.damore@gmail.com>)
