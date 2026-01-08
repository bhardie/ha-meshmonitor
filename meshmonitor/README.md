# Home Assistant Add-on: MeshMonitor

MeshMonitor is a comprehensive web application for monitoring Meshtastic mesh networks over IP.

## About

This add-on wraps the [MeshMonitor](https://github.com/yeraze/meshmonitor) application, providing real-time visibility into your Meshtastic mesh network deployment with features like:

- Live node discovery
- Telemetry tracking
- Network visualization
- Message monitoring

## Installation

1. Add this repository to your Home Assistant add-on store
2. Install the "MeshMonitor" add-on
3. Configure your Meshtastic node IP address
4. Start the add-on
5. Access the web interface

## Configuration

### Option: `meshtastic_node_ip`

The IP address of your Meshtastic node on your network.

**Required**: Yes

**Default**: `192.168.1.100`

Example:
```yaml
meshtastic_node_ip: "192.168.1.150"
```

### Option: `allowed_origins`

Comma-separated list of allowed origins for CORS (Cross-Origin Resource Sharing). This controls which URLs are allowed to access the MeshMonitor web interface.

**Required**: No

**Default**: Auto-detect from Home Assistant, fallback to `*` (all origins)

**IMPORTANT**: Use the port configured in the "Network" section of this add-on's configuration (default: 3001), NOT Home Assistant's port (8123).

Example:
```yaml
allowed_origins: "http://homeassistant.local:3001,http://192.168.1.10:3001,https://abcdefg123.ui.nabu.casa:3001"
```

**When to configure this:**
- You experience login failures with "Invalid username or password" or CORS errors
- You access Home Assistant from multiple URLs (hostname, IP, external domain, etc.)
- Auto-detection is not working (API returns null)
- You want explicit control over CORS security

**How to determine your URLs:**
1. Check Settings → Add-ons → MeshMonitor → Configuration → Network
2. Note the port number (default is 3001)
3. List all the hostnames/IPs you use to access Home Assistant, using the MeshMonitor port
4. Include all variations: `http://hostname:3001`, `http://ip:3001`, `https://external-domain:3001`

If not configured, the add-on will attempt to auto-detect your Home Assistant URLs from the Supervisor API. If auto-detection fails, it falls back to allowing all origins (`*`), which works but is less secure.

## Usage

1. After starting the add-on, click "Open Web UI" to access MeshMonitor
2. Default credentials are:
   - Username: `admin`
   - Password: `changeme`
3. Change the password after first login
4. Configure your mesh network settings as needed

## Security

This add-on uses CORS (Cross-Origin Resource Sharing) to control which URLs can access the MeshMonitor web interface. There are three ways CORS is configured, in order of priority:

### 1. Manual Configuration (Recommended)

Set the `allowed_origins` option in the add-on configuration with all the URLs you use to access MeshMonitor. **Important**: Use the MeshMonitor port (default 3001), not Home Assistant's port (8123).

```yaml
allowed_origins: "http://homeassistant.local:3001,http://192.168.1.10:3001,https://abcdefg123.ui.nabu.casa:3001"
```

This is the most secure option and works best if you access Home Assistant from multiple URLs (hostname, IP address, external domain, etc.).

### 2. Auto-Detection

If `allowed_origins` is not configured, the add-on will attempt to auto-detect your Home Assistant URLs from the Supervisor API. However, this may not work reliably as the API often returns `null` for these values.

### 3. Fallback to Allow All

If neither manual configuration nor auto-detection provides URLs, the add-on falls back to `allowed_origins: "*"` (all origins allowed) with a warning in the logs. While this ensures the add-on works, it's less secure.

**Check the logs** after starting the add-on to see which method is being used.

## Updating MeshMonitor

This add-on uses the `:latest` tag of the upstream [MeshMonitor](https://github.com/yeraze/meshmonitor) Docker image. This means you'll get MeshMonitor updates when:

1. The add-on version is bumped (e.g., from 0.0.1 to 0.0.2), which triggers a rebuild
2. You manually rebuild the add-on in Home Assistant

**To get the latest MeshMonitor version:**

1. Check for add-on updates in Settings → Add-ons → MeshMonitor
2. If an update is available, click "Update"
3. Restart the add-on

**Note**: Since this is a personal project, I may not immediately release new versions when upstream MeshMonitor updates. If you want to force an update to the latest MeshMonitor version, you can:
1. Uninstall the add-on (make sure to back up your configuration and data first)
2. Reinstall it from the add-on store

Alternatively, you can watch the [MeshMonitor releases](https://github.com/yeraze/meshmonitor/releases) and open an issue requesting a version bump.

## Support

For issues with this add-on, please open an issue on [GitHub](https://github.com/bhardie/ha-meshmonitor/issues).

For issues with MeshMonitor itself, see the [upstream project](https://github.com/yeraze/meshmonitor).
