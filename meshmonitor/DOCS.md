# Home Assistant Add-on: Meshmonitor

## Introduction

Meshmonitor is a Home Assistant add-on that enables you to monitor and manage your mesh network from within Home Assistant.

## Features

- Monitor mesh network status
- View connected devices
- Network performance metrics
- Web-based interface

## Configuration

The add-on can be configured through the Home Assistant interface.

### Available Configuration Options

#### Option: `log_level` (required)

Controls the verbosity of log output. Available options are:
- `trace`: Show every detail, like all called internal functions
- `debug`: Shows detailed debug information
- `info`: Normal (usually) interesting events
- `notice`: Normal but significant events
- `warning`: Exceptional occurrences that are not errors
- `error`: Runtime errors that do not require immediate action
- `fatal`: Something went terribly wrong

Default value: `info`

## Usage

After starting the add-on:

1. Access the web interface on port 8080
2. Configure your mesh network settings
3. Monitor your network from the dashboard

## Support

For help or to report issues, please visit the [GitHub repository](https://github.com/bhardie/ha-meshmonitor).
