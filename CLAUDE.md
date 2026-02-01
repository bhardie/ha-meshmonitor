# CLAUDE.md - Home Assistant MeshMonitor Add-on

## Project Overview

This is a Home Assistant add-on that wraps [MeshMonitor](https://github.com/yeraze/meshmonitor), a web application for monitoring Meshtastic mesh networks over IP. The add-on packages the upstream MeshMonitor Docker image with Home Assistant-specific configuration and startup scripts.

**Repository**: https://github.com/bhardie/ha-meshmonitor
**Upstream Project**: https://github.com/yeraze/meshmonitor
**Maintainer**: Brian Hardie
**License**: MIT (for the add-on wrapper; MeshMonitor has its own license)

## Terminology / Shorthand

- **mm**: MeshMonitor (the upstream application)
- **ha-mm** or **hamm**: This Home Assistant wrapper project (ha-meshmonitor)

Example usage: "Update mm to 3.4.1 in ha-mm" means "Update MeshMonitor to version 3.4.1 in the Home Assistant wrapper"

## Repository Structure

```
ha-meshmonitor/
├── meshmonitor/              # The add-on itself
│   ├── CHANGELOG.md          # Version history and changes
│   ├── README.md             # User-facing documentation
│   ├── config.yaml           # Add-on metadata and options schema
│   ├── build.yaml            # Docker base image configuration
│   ├── Dockerfile            # Add-on container build instructions
│   ├── run.sh                # Startup script and configuration logic
│   ├── icon.png              # Add-on icon
│   └── logo.png              # Add-on logo
├── README.md                 # Repository overview
├── repository.yaml           # Home Assistant add-on repository metadata
├── LICENSE                   # MIT License
└── .gitignore                # Git ignore patterns
```

## Key Files

### `meshmonitor/config.yaml`
Defines the add-on metadata visible to Home Assistant users:
- **version**: The add-on version (format: `"0.0.X"`)
- **name, description, slug**: Add-on identification
- **arch**: Supported architectures (aarch64, amd64, armhf, armv7, i386)
- **ports**: Port mappings (default: 3001 for web UI)
- **options**: User-configurable settings with defaults
- **schema**: Validation rules for options

### `meshmonitor/build.yaml`
Specifies the Docker base image for each architecture:
- Uses `ghcr.io/yeraze/meshmonitor:X.Y.Z` images
- All architectures use the same version tag
- This is the PRIMARY location to update MeshMonitor version

### `meshmonitor/Dockerfile`
Builds on top of the MeshMonitor image:
- Installs additional dependencies (`jq` and `curl` for configuration parsing)
- Copies and sets up the `run.sh` startup script
- Sets custom entrypoint

### `meshmonitor/run.sh`
Startup script that:
- Reads user configuration from `/data/options.json`
- Configures `MESHTASTIC_NODE_IP` environment variable
- Handles CORS `ALLOWED_ORIGINS` (manual config, auto-detection, or fallback)
- Filters logs to prevent disk space issues (removes `[INFO]` and `[DEBUG]` messages)
- Launches MeshMonitor via supervisord

### `meshmonitor/CHANGELOG.md`
Maintains version history in Keep a Changelog format:
- Each version has a date in `YYYY-MM-DD` format
- Categorizes changes under `### Changed`, `### Added`, `### Fixed`, etc.
- Most updates are MeshMonitor version bumps

## Version Management

This project tracks two separate versions:

1. **Add-on version** (`config.yaml`): Increments for any change to the add-on
2. **MeshMonitor version** (`build.yaml`): Upstream application version

### Versioning Convention
- Add-on uses semantic versioning: `0.0.X`
- Typically increments by 0.0.1 for each MeshMonitor update
- Current versions are the source of truth in `config.yaml` (add-on) and `build.yaml` (mm)

## Common Development Tasks

### Updating MeshMonitor Version

When a new MeshMonitor release is available:

1. **Update `meshmonitor/build.yaml`**:
   - Change all architecture tags to new version (e.g., `3.4.1`)

2. **Bump add-on version in `meshmonitor/config.yaml`**:
   - Increment version (e.g., `"0.0.5"` → `"0.0.6"`)

3. **Update `meshmonitor/CHANGELOG.md`**:
   - Add new entry at the top with current date
   - Follow existing format:
     ```markdown
     ## [0.0.X] - YYYY-MM-DD

     ### Changed
     - Updated MeshMonitor to vX.Y.Z
     ```

4. **Commit changes**:
   ```bash
   git add meshmonitor/build.yaml meshmonitor/config.yaml meshmonitor/CHANGELOG.md
   git commit -m "Update MeshMonitor to vX.Y.Z"
   git push
   ```

### Viewing Recent Commits
The git history shows a pattern of version bump commits:
```
c5cd072 Update MeshMonitor to v3.3.0
9721523 Update MeshMonitor to v3.2.4
5dd611a Update MeshMonitor to v2.22.1 and pin version
2198540 Add log filtering to prevent disk space issues
```

## Technical Details

### CORS Configuration
The add-on handles CORS (Cross-Origin Resource Sharing) in three ways:
1. **Manual**: User sets `allowed_origins` in config
2. **Auto-detection**: Queries Home Assistant Supervisor API for URLs
3. **Fallback**: Uses `"*"` (all origins) if detection fails

### Log Filtering
To prevent disk space issues, `run.sh` filters out `[INFO]` and `[DEBUG]` messages:
```bash
grep -v -E "^\[(INFO|DEBUG)\]" || true
```
This reduces log volume by 80-90% while keeping warnings and errors.

### Port Configuration
- Default port: **3001** (configurable by user)
- Important: Users should use the MeshMonitor port in `allowed_origins`, NOT Home Assistant's port (8123)

### Home Assistant Integration
- Uses `homeassistant_api: true` for API access
- Reads configuration from `/data/options.json`
- Accesses Supervisor API via `http://supervisor/` with `SUPERVISOR_TOKEN`

## Development Workflow

1. **Make changes** to add-on files
2. **Test locally** (if applicable)
3. **Update version numbers** (config.yaml, CHANGELOG.md)
4. **Commit with descriptive message**
5. **Push to GitHub**
6. Home Assistant users update via Settings → Add-ons → Update

## Important Conventions

- **Personal project disclaimer**: This is shared "as-is" with no guarantees
- **Pull requests welcome**: Contributors can fork and submit PRs
- **Minimal scope**: The add-on only wraps MeshMonitor; feature requests for MeshMonitor itself go upstream
- **Documentation in README**: User-facing docs are comprehensive in `meshmonitor/README.md`
- **No emoji usage**: Keep commits and documentation professional and concise

## Dependencies

### Runtime
- **MeshMonitor**: The upstream application (Docker image)
- **jq**: JSON parsing for configuration
- **curl**: HTTP requests to Supervisor API

### Home Assistant
- **Supervisor API**: For auto-detecting URLs
- **Add-on system**: For configuration, networking, and lifecycle management

## Notes for AI Assistants

- When updating versions, ALWAYS update all three files: `build.yaml`, `config.yaml`, and `CHANGELOG.md`
- Follow the existing commit message format: `"Update MeshMonitor to vX.Y.Z"`
- Today's date is used in CHANGELOG entries (format: YYYY-MM-DD)
- The project doesn't use additional scripts or automation - it's intentionally simple
- Don't suggest adding features to MeshMonitor itself - this is just a wrapper
- Keep changes minimal and focused - this is a personal project with a small scope
