# Homebrew Reqtap

[![Build Status](https://github.com/funnyzak/homebrew-reqtap/workflows/CI/badge.svg)](https://github.com/funnyzak/homebrew-reqtap/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This is the official Homebrew tap for [ReqTap](https://github.com/funnyzak/reqtap), a powerful HTTP request debugging tool built in Go.

## What is ReqTap?

ReqTap is a modern, feature-rich HTTP request debugging and monitoring tool that provides:

- **Real-time HTTP monitoring**: Capture and analyze HTTP/HTTPS requests in real-time
- **Web-based management interface**: Intuitive web UI for configuration and monitoring
- **Zero dependencies**: Single binary deployment with no external dependencies
- **Cross-platform support**: Works on macOS, Linux, and Windows
- **Multiple architectures**: Support for Intel, Apple Silicon, ARM, and more
- **Powerful filtering and search**: Advanced filtering capabilities for request analysis
- **Request/Response inspection**: Detailed view of headers, body, and metadata
- **Export capabilities**: Export captured data for further analysis

## Installation

### Prerequisites

- macOS 10.15 or later
- [Homebrew](https://brew.sh/) installed

### Install ReqTap

```bash
# Add the tap
brew tap funnyzak/reqtap

# Install reqtap
brew install reqtap
```

### Verify Installation

```bash
reqtap --version
```

## Usage

After installation, you can start using ReqTap immediately:

```bash
# Start reqtap with default settings
reqtap

# Start with custom configuration
reqtap --config /path/to/config.yaml

# Start on a specific port
reqtap --port 8080

# Start web management interface
reqtap --web
```

For detailed usage instructions, please refer to the [official ReqTap documentation](https://github.com/funnyzak/reqtap#readme).

## Update

To update ReqTap to the latest version:

```bash
brew update && brew upgrade reqtap
```

## Uninstallation

To completely remove ReqTap:

```bash
# Uninstall the formula
brew uninstall reqtap

# Remove the tap (optional)
brew untap funnyzak/reqtap
```

## Configuration

ReqTap can be configured through:

1. **Command-line flags**: Use `reqtap --help` to see all available options
2. **Configuration file**: Create a YAML configuration file and specify with `--config`
3. **Environment variables**: Various settings can be controlled via environment variables

Example configuration file (`config.yaml`):

```yaml
server:
  port: 8080
  host: "0.0.0.0"

proxy:
  enabled: true
  port: 8888

logging:
  level: "info"
  file: "/var/log/reqtap.log"

web:
  enabled: true
  port: 8081
```

## Troubleshooting

### Common Issues

**1. Permission denied error**
```bash
sudo chown -R $(whoami) $(brew --prefix)/Cellar/reqtap
```

**2. Command not found**
```bash
# Check if brew is in your PATH
echo $PATH | grep brew

# If not, add to your shell profile (~/.zshrc or ~/.bash_profile)
export PATH="/opt/homebrew/bin:$PATH"  # For Apple Silicon Macs
export PATH="/usr/local/bin:$PATH"    # For Intel Macs
```

**3. Version conflicts**
```bash
# Completely remove and reinstall
brew uninstall --ignore-dependencies reqtap
brew install reqtap
```

### Getting Help

- [ReqTap GitHub Issues](https://github.com/funnyzak/reqtap/issues)
- [Homebrew Documentation](https://docs.brew.sh/)
- [Homebrew Troubleshooting](https://docs.brew.sh/Troubleshooting)

## Development

This tap follows Homebrew best practices and includes automated update scripts.

### Manual Update Process

The formula can be manually updated using the provided update script:

```bash
# Run the update script
./scripts/update-formula.rb
```

This script will:
- Fetch the latest release information from GitHub
- Update the version number
- Download and verify checksums for new binaries
- Update the formula file with new URLs and checksums

### Automated Updates

This repository includes GitHub Actions workflows that automatically:
- Check for new releases daily
- Update the formula when new versions are detected
- Run tests to ensure the updated formula works correctly
- Submit pull requests for review

## Contributing

We welcome contributions! Please follow these steps:

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This Homebrew tap is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

The ReqTap tool itself is also licensed under the MIT License. For more information, please refer to the [ReqTap repository](https://github.com/funnyzak/reqtap).

## Related Links

- [ReqTap Main Repository](https://github.com/funnyzak/reqtap)
- [Homebrew Documentation](https://docs.brew.sh/)
- [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)

## Support

If you encounter any issues with the Homebrew formula specifically, please [open an issue](https://github.com/funnyzak/homebrew-reqtap/issues) in this repository.

For issues with the ReqTap application itself, please [open an issue](https://github.com/funnyzak/reqtap/issues) in the main ReqTap repository.