# SpeedTest CLI

A lightweight, cross-platform internet speed test tool for Windows PowerShell that provides accurate download/upload speed measurements and network diagnostics.

## ⚡ Quick Install

```powershell
irm https://get.speedtest.dev | iex
```

## 🌟 Features

- **Fast & Accurate**: Tests download and upload speeds using multiple reliable servers
- **Network Diagnostics**: Measures ping latency and detects network issues  
- **Location Detection**: Automatically identifies your ISP and geographic location
- **Multiple Formats**: Choose between detailed results or simple one-line output
- **Easy Installation**: One-command global installation with automatic PATH setup
- **No Dependencies**: Pure PowerShell - no external tools required
- **Privacy Focused**: No data collection or tracking

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

### Option 1: One-Line Install (Recommended)
```powershell
irm https://get.speedtest.dev | iex
```

### Option 2: Manual Install
1. Download the script:
   ```powershell
   Invoke-WebRequest -Uri "https://get.speedtest.dev" -OutFile "speedtest.ps1"
   ```
2. Install globally:
   ```powershell
   .\speedtest.ps1 -Install
   ```

### Option 3: Portable Use
```powershell
# Run directly without installation
irm https://get.speedtest.dev | iex
```

## 💻 Usage

### Basic Commands
```powershell
# Run a standard speed test
speedtest

# Simple one-line output
speedtest -Simple

# Detailed verbose output  
speedtest -Verbose

# Custom test duration (default: 10 seconds)
speedtest -Duration 15

# Test with specific server
speedtest -Server "https://speed.cloudflare.com/__down?bytes=100000000"
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
| `-Duration <n>` | Set test duration in seconds (default: 10) | `speedtest -Duration 15` |
| `-Server <url>` | Use custom test server URL | `speedtest -Server "https://example.com/test"` |
| `-Install` | Install globally for system-wide access | `speedtest -Install` |
| `-Uninstall` | Remove the installed tool | `speedtest -Uninstall` |
| `-Help` | Show detailed help information | `speedtest -Help` |

## 🔧 How It Works

SpeedTest CLI performs comprehensive network testing through multiple methods:

### Download Speed Test
- Uses multiple high-performance test servers (OVH, Cloudflare, Google)
- Downloads data for specified duration and measures throughput
- Automatically selects the best performing server
- Reports speed in Mbps (Megabits per second)

### Upload Speed Test  
- Uploads random data to HTTP test endpoints
- Measures sustained upload throughput
- Uses reliable public testing services
- Accounts for protocol overhead

### Ping Test
- Tests latency to Google DNS (8.8.8.8)
- Performs multiple ping tests for accuracy
- Reports average response time in milliseconds

### Network Information
- Detects public IP address using multiple services
- Identifies ISP and geographic location
- Provides connection context for results

## 🌐 Test Servers

The tool automatically uses multiple test servers for reliability:

- **OVH**: High-performance European servers
- **Cloudflare**: Global CDN with excellent coverage  
- **Google**: Reliable infrastructure with worldwide presence
- **HTTPBin**: For upload testing and diagnostics

## 📁 Installation Details

### File Locations
- **Script**: `%USERPROFILE%\.local\bin\speedtest.ps1`
- **Batch Wrapper**: `%USERPROFILE%\.local\bin\speedtest.bat`
- **Install Directory**: `%USERPROFILE%\.local\bin\`

### PATH Management
The installer automatically:
- Creates the local bin directory if it doesn't exist
- Adds the bin directory to your user PATH
- Creates a batch wrapper for easy command access
- Handles PowerShell execution policy requirements

## 🛠️ Troubleshooting

### Common Issues

**"speedtest is not recognized as a command"**
- Restart your terminal after installation
- Check if `%USERPROFILE%\.local\bin` is in your PATH
- Run `speedtest -Install` again to repair the installation

**PowerShell execution policy errors**
- Run: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
- Or use: `powershell -ExecutionPolicy Bypass -File speedtest.ps1`

**Slow or failed speed tests**
- Check your internet connection
- Try running with `-Verbose` for detailed diagnostics  
- Firewall or proxy settings may interfere with testing
- Some corporate networks block speed test traffic

**"No internet connection detected"**
- Verify you can reach `8.8.8.8` (Google DNS)
- Check if ping is blocked by your firewall
- Try disabling VPN temporarily

### Network Requirements
- Outbound HTTP/HTTPS access (ports 80/443)
- Ability to reach multiple test server domains
- ICMP ping access to 8.8.8.8 (for ping tests)

## 🔒 Privacy & Security

- **No Data Collection**: The tool doesn't collect or transmit personal data
- **No Account Required**: Works completely anonymously  
- **Open Source**: Full source code is available for inspection
- **Local Processing**: All calculations performed on your machine
- **Secure Connections**: Uses HTTPS for all speed tests

## 🤝 Contributing

Contributions are welcome! Please feel free to:

- Report bugs or issues
- Suggest new features or improvements
- Submit pull requests
- Improve documentation

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆚 Comparison with Other Tools

| Feature | SpeedTest CLI | Ookla Speedtest | Fast.com |
|---------|---------------|-----------------|----------|
| Installation | One command | Multi-step | Browser only |
| Command Line | ✅ | ✅ | ❌ |
| No Registration | ✅ | ❌ | ✅ |
| Multiple Servers | ✅ | ✅ | ❌ |
| Ping Testing | ✅ | ✅ | ❌ |
| Offline Capable | ✅ | ❌ | ❌ |
| Open Source | ✅ | ❌ | ❌ |

## 📞 Support

- **Issues**: Report bugs and feature requests via GitHub Issues
- **Documentation**: Check this README for comprehensive usage information
- **Community**: Join discussions in GitHub Discussions

---

**Made with ❤️ for the PowerShell community**