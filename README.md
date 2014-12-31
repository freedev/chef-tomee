# tomee-cookbook

Installs and configures Apache TomEE, all-Apache Java EE 6 Web Profile.

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
