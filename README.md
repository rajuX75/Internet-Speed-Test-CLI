# SpeedTest CLI

A lightweight, cross-platform internet speed test tool for Windows, Linux, and macOS that provides accurate download/upload speed measurements and network diagnostics.

## ⚡ Quick Install

### Windows
```powershell
irm https://get.speedtest.dev | iex
```

### Linux / macOS
```bash
curl -s https://get.speedtest.dev/install.sh | bash
```

## 🌟 Features

- **Fast & Accurate**: Tests download and upload speeds using Cloudflare's network.
- **Network Diagnostics**: Measures ping latency.
- **Location Detection**: Automatically identifies your ISP and geographic location.
- **Multiple Formats**: Choose between detailed results or simple one-line output.
- **Easy Installation**: One-command global installation.
- **No Dependencies**: Pure PowerShell on Windows. On Linux/macOS it requires PowerShell to be installed.
- **Privacy Focused**: No data collection or tracking.

## 📊 Example Output

```
╔══════════════════════════════════════════╗
║            SPEED TEST RESULTS            ║
╠══════════════════════════════════════════╣
║                                          ║
║  Public IP:    203.0.113.42              ║
║  ISP:          Example Internet Provider ║
║  Location:     New York, United States   ║
║                                          ║
║  Download:       85.43 Mbps              ║
║  Upload:         12.67 Mbps              ║
║  Ping:           23.45 ms                ║
║                                          ║
╚══════════════════════════════════════════╝
```

## 🚀 Installation

### Windows (PowerShell)
```powershell
irm https://get.speedtest.dev | iex
```

### Linux / macOS (Bash)
```bash
curl -s https://get.speedtest.dev/install.sh | bash
```

### Manual Installation
1. Download the `speedtest.ps1` script.
2. Run `pwsh -File speedtest.ps1 -Install`

## 💻 Usage

### Basic Commands
```powershell
# Run a standard speed test
speedtest

# Simple one-line output
speedtest -Simple

# Detailed verbose output  
speedtest -Verbose
```

### Advanced Options
```powershell
# Show help and all options
speedtest -Help

# Install the tool globally
speedtest -Install

# Uninstall the tool
speedtest -Uninstall
```

## 📋 Command Line Options

| Option | Description | Example |
|--------|-------------|---------|
| `-Simple` | Show results in one line format | `speedtest -Simple` |
| `-Verbose` | Display detailed testing information | `speedtest -Verbose` |
| `-Install` | Install globally for system-wide access | `speedtest -Install` |
| `-Uninstall` | Remove the installed tool | `speedtest -Uninstall` |
| `-Help` | Show detailed help information | `speedtest -Help` |

## Notes
* This script is not perfect and may not work on all systems.
* The upload speed measurement can be unreliable on some networks.
* The ping measurement is performed against `8.8.8.8` (Google DNS).

## 📄 License

This project is licensed under the MIT License.
