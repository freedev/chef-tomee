# tomee

This cookbook installs and configures Apache TomEE. 
It defaults to downloading TomEE from an tomee_url you specify in attributes/default.rb
This cookbook is inspired and built on Opscode's Tomcat cookbook.

## Supported Platforms

- Debian, Ubuntu (OpenJDK, Oracle)
- CentOS 6+, Red Hat 6+, Fedora, Amaxon (OpenJDK, Oracle), Scientific Linux 6

### Dependencies
- java

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
</table>

## Usage

### tomee::tomee

Include `tomee` in your node's `run_list`:

```json
{
  "run_list": [
    'recipe[tomee::common-packages]',
    'recipe[java::default]',
    'recipe[tomee::tomee]'
  ]
}
```

## License and Authors

Author:: Vincenzo D'Amore (<v.damore@gmail.com>)
