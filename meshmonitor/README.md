# Home Assistant Add-on: Meshmonitor

## About

This add-on allows you to monitor and manage your mesh network directly from Home Assistant.

## Installation

1. Add this repository to your Home Assistant instance:
   [![Add Repository][repository-badge]][repository-url]

2. Install the "Meshmonitor" add-on
3. Start the add-on
4. Check the logs to see if everything went well

## Configuration

Add-on configuration:

```yaml
log_level: info
```

### Option: `log_level`

The `log_level` option controls the level of log output by the add-on.
Valid values are: `trace`, `debug`, `info`, `notice`, `warning`, `error`, `fatal`.

## Support

Got questions?

Open an issue on [GitHub][issues].

## Authors & contributors

The original setup of this repository is by [Brian Hardie][bhardie].

## License

MIT License

Copyright (c) 2025 Brian Hardie

[bhardie]: https://github.com/bhardie
[issues]: https://github.com/bhardie/ha-meshmonitor/issues
[repository-badge]: https://img.shields.io/badge/Add%20repository%20to%20HA-41BDF5?logo=home-assistant&style=for-the-badge
[repository-url]: https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fbhardie%2Fha-meshmonitor
