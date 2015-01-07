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
    <td><tt>['tomee']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### tomee::default

Include `tomee` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[tomee::default]"
  ]
}
```

## License and Authors

Author:: YOUR_NAME (<YOUR_EMAIL>)
