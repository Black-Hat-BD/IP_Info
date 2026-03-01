# IP_Info
IP information gathering
# 🔍 Advanced IP Reconnaissance Tool v2.0

A comprehensive, professional-grade IP address intelligence gathering tool written in Ruby. This tool provides extensive information about any IP address including geolocation, network data, security analysis, port scanning, and much more.

---

## 📋 Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Menu Options](#menu-options)
- [Examples](#examples)
- [Legal Disclaimer](#legal-disclaimer)
- [Troubleshooting](#troubleshooting)
- [API Sources](#api-sources)

---

## ✨ Features

### 🌍 Comprehensive IP Intelligence
- **Quick IP Lookup** - Fast basic information retrieval
- **Deep Analysis** - Multi-source data aggregation
- **Geolocation Data** - Precise geographic coordinates and mapping
- **Network Information** - DNS, PTR, A, MX, NS records
- **Port Scanning** - Check common ports (FTP, SSH, HTTP, HTTPS, etc.)
- **WHOIS Lookup** - Domain registration information
- **Security Analysis** - Threat detection, proxy/VPN detection
- **Batch Processing** - Analyze multiple IPs at once
- **Data Export** - Save results in JSON or TXT format

### 🎨 Advanced Features
- Color-coded terminal output for better readability
- Interactive menu system
- Command-line argument support
- Multiple API integration (IP-API, IPInfo, IPData)
- Rate limiting and error handling
- Session duration tracking
- Comprehensive error messages

### 📊 Information Collected

#### Geographic Data:
- Country, Region, City
- ZIP/Postal Code
- Latitude & Longitude
- Timezone
- Currency
- Continent
- Language

#### Network Data:
- IP Address (IPv4/IPv6)
- Hostname
- ISP (Internet Service Provider)
- Organization
- AS Number (Autonomous System)
- DNS Records (A, PTR, MX, NS)
- Reverse DNS

#### Security Indicators:
- Proxy/VPN Detection
- Mobile Network Detection
- Hosting/Datacenter Identification
- Threat Level Assessment
- Open Port Detection
- Blacklist Status

#### Additional Data:
- Map Links (Google Maps, OpenStreetMap, Bing Maps)
- Calling Codes
- Domain Information
- Registration Data

---

## 🚀 Installation

### Prerequisites

- Ruby 2.5 or higher
- Internet connection
- Termux (for Android) or any Unix-like terminal

### Termux Installation (Android)

```bash
# Update packages
pkg update && pkg upgrade

# Install Ruby
pkg install ruby

# Install required gems (optional, all built-in)
gem install json

# Download the script
# (Copy the ip_recon.rb file to your device)

# Make it executable
chmod +x ip_recon.rb
```

### Linux/macOS Installation

```bash
# Ruby should be pre-installed on most systems
# Check Ruby version
ruby --version

# If not installed:
# Ubuntu/Debian
sudo apt-get install ruby-full

# macOS (using Homebrew)
brew install ruby

# Make script executable
chmod +x ip_recon.rb
```

### Windows Installation

1. Install Ruby from [rubyinstaller.org](https://rubyinstaller.org/)
2. Download the script
3. Run from Command Prompt or PowerShell:
```
ruby ip_recon.rb
```

---

## 💻 Usage

### Interactive Mode (Menu-Driven)

Simply run the script without arguments:

```bash
ruby ip_recon.rb
```

This launches the interactive menu where you can select from various options.

### Command Line Mode (Quick Analysis)

Provide an IP address as an argument for automatic deep analysis:

```bash
ruby ip_recon.rb 8.8.8.8
ruby ip_recon.rb 1.1.1.1
ruby ip_recon.rb 142.250.185.46
```

---

## 📖 Menu Options

### Main Menu

```
1. Quick IP Lookup (Basic Information)
   - Fast basic IP information
   - Country, city, ISP, coordinates
   - Proxy/VPN detection

2. Deep IP Analysis (Comprehensive Scan)
   - Multi-source data aggregation
   - Combines data from 3+ APIs
   - Comprehensive report generation

3. Network Information & DNS Lookup
   - Hostname resolution
   - PTR (Reverse DNS) records
   - A, MX, NS record lookup
   - Domain nameserver information

4. Port Scanning (Common Ports)
   - Scans 16 common ports
   - FTP, SSH, HTTP, HTTPS, MySQL, RDP, etc.
   - Security risk assessment
   - ⚠️ Use only on authorized systems

5. WHOIS Information
   - Domain registration data
   - Registrar information
   - Creation/expiration dates
   - Domain status

6. Geolocation & Map Data
   - Precise coordinates
   - Multiple map service links
   - Google Maps, OpenStreetMap, Bing
   - Timezone information

7. Security & Threat Analysis
   - Threat level detection
   - Proxy/VPN identification
   - Open port security assessment
   - Security recommendations

8. Batch IP Lookup (Multiple IPs)
   - Analyze multiple IPs sequentially
   - Summary statistics
   - Bulk data collection

9. Export Results (JSON/TXT)
   - Save scan results
   - JSON format for parsing
   - TXT format for reports
   - Timestamped filenames

10. Check My Public IP
    - Find your public IP address
    - Optional analysis of your IP
    - Privacy information

0. Exit
   - Display session duration
   - Clean exit
```

---

## 📝 Examples

### Example 1: Quick Google DNS Lookup

```bash
$ ruby ip_recon.rb

Select option: 1
Enter target IP: 8.8.8.8

[*] Performing Quick IP Lookup...

==================================================
            BASIC IP INFORMATION
==================================================
  IP Address          : 8.8.8.8
  Country             : United States (US)
  Region              : California
  City                : Mountain View
  ISP                 : Google LLC
  Organization        : Google Public DNS
  AS Number           : AS15169 Google LLC
  Hosting             : Yes
==================================================
```

### Example 2: Deep Analysis

```bash
$ ruby ip_recon.rb 1.1.1.1

[*] Initiating Deep IP Analysis...
[*] Fetching from IP-API.com... ✓
[*] Fetching from IPInfo.io... ✓
[*] Fetching from IPData.co... ✓

==================================================
      COMPREHENSIVE IP ANALYSIS REPORT
==================================================

[ GEOGRAPHICAL INFORMATION ]
--------------------------------------------------
  Country              : Australia (AU)
  City                 : Sydney
  Latitude             : -33.8688
  Longitude            : 151.2093
  Timezone             : Australia/Sydney

[ NETWORK INFORMATION ]
--------------------------------------------------
  AS Number            : AS13335 Cloudflare, Inc.
  ISP                  : Cloudflare, Inc
  Hostname             : one.one.one.one

[ SECURITY INDICATORS ]
--------------------------------------------------
  Proxy                : No
  Hosting/Datacenter   : Yes
  Threat Level         : None
==================================================
```

### Example 3: Port Scanning

```bash
Select option: 4
Enter target IP: 192.168.1.1

[!] WARNING: Port scanning may be illegal in some jurisdictions.
[!] Only scan IPs you own or have permission to test.

Continue? (yes/no): yes

[*] Scanning port 80 (HTTP)... OPEN
[*] Scanning port 443 (HTTPS)... OPEN
[*] Scanning port 22 (SSH)... CLOSED
...

==================================================
            PORT SCAN RESULTS
==================================================

[+] Open Ports:
  Port 80 - HTTP
  Port 443 - HTTPS

[*] Total Ports Scanned: 16
[+] Open Ports: 2
[-] Closed Ports: 14
==================================================
```

### Example 4: Batch Processing

```bash
Select option: 8

[*] Batch IP Lookup Mode
Enter IP addresses (one per line, empty line to finish):

IP 1: 8.8.8.8
IP 2: 1.1.1.1
IP 3: 9.9.9.9
IP 4: [Press Enter]

[*] Processing 3 IP addresses...

==================================================
[1/3] Analyzing: 8.8.8.8
==================================================
...

==================================================
          BATCH LOOKUP SUMMARY
==================================================
Total IPs processed: 3
Successful lookups: 3
Failed lookups: 0
==================================================
```

### Example 5: Command Line Usage

```bash
# Quick analysis from command line
$ ruby ip_recon.rb 8.8.8.8

# The tool will automatically perform:
# - Deep IP Analysis
# - Network Information lookup
# - Security Analysis
```

---

## ⚖️ Legal Disclaimer

**IMPORTANT: READ BEFORE USE**

This tool is provided for **EDUCATIONAL AND AUTHORIZED TESTING PURPOSES ONLY**.

### Legal Usage:
✅ Testing your own systems
✅ Educational and research purposes
✅ Authorized security assessments
✅ With explicit written permission from the IP owner

### Illegal Usage:
❌ Scanning systems without authorization
❌ Attempting to exploit discovered vulnerabilities
❌ Harvesting data for malicious purposes
❌ Any activity that violates local or international law

### User Responsibilities:
- You are solely responsible for how you use this tool
- Ensure you have proper authorization before scanning any IP
- Comply with all applicable laws and regulations
- Respect privacy and terms of service of all APIs used

### Port Scanning Warning:
Port scanning may be considered an attack or reconnaissance activity in many jurisdictions. The tool includes warnings before performing port scans. Always obtain explicit permission before scanning any system you do not own.

**The developers assume no liability for misuse of this tool.**

---

## 🔧 Troubleshooting

### Common Issues and Solutions

#### Issue: "Connection refused" or "Timeout" errors

**Solution:**
```bash
# Check internet connection
ping google.com

# Check if Ruby can make HTTP requests
ruby -rnet/http -e "puts Net::HTTP.get(URI('http://www.google.com'))"

# Some networks may block certain APIs
# Try using a VPN or different network
```

#### Issue: "Invalid IP address format"

**Solution:**
- Ensure IP is in correct format: `xxx.xxx.xxx.xxx`
- Each octet must be 0-255
- No spaces or special characters
```bash
# Valid examples:
8.8.8.8
192.168.1.1
142.250.185.46

# Invalid examples:
888.8.8.8 (first octet > 255)
8.8.8 (incomplete)
8.8.8.8.8 (too many octets)
```

#### Issue: "No data returned" or "API rate limit"

**Solution:**
- Wait a few minutes between requests
- Some APIs have rate limits
- Try the quick lookup instead of deep analysis
```bash
# Rate limiting example:
# If you get errors, wait 60 seconds
sleep 60
ruby ip_recon.rb
```

#### Issue: Ruby not found

**Solution:**
```bash
# Termux
pkg install ruby

# Ubuntu/Debian
sudo apt-get install ruby-full

# Check installation
ruby --version
which ruby
```

#### Issue: Permission denied

**Solution:**
```bash
# Make script executable
chmod +x ip_recon.rb

# Or run with ruby command
ruby ip_recon.rb
```

#### Issue: Port scanning always shows "CLOSED"

**Solution:**
- Firewall may be blocking outbound connections
- Target firewall may be dropping packets
- Increase timeout in the code (default is 2 seconds)
- Some ports may be filtered (not responding)

#### Issue: Colors not showing properly

**Solution:**
```bash
# Some terminals don't support ANSI colors
# Try different terminal emulator
# On Windows, use Windows Terminal or ConEmu

# Disable colors by modifying Colors class:
# Change color codes to empty strings
```

---

## 🌐 API Sources

This tool aggregates data from multiple free API sources:

### IP-API.com
- **Endpoint:** `http://ip-api.com/json/`
- **Features:** Geolocation, ISP, AS number, proxy detection
- **Rate Limit:** 45 requests/minute
- **Documentation:** https://ip-api.com/docs

### IPInfo.io
- **Endpoint:** `https://ipinfo.io/`
- **Features:** Basic IP data, hostname, organization
- **Rate Limit:** 50,000 requests/month (free tier)
- **Documentation:** https://ipinfo.io/developers

### IPData.co
- **Endpoint:** `https://api.ipdata.co/`
- **Features:** Comprehensive data, threat intelligence
- **Rate Limit:** 1,500 requests/day (free tier)
- **Documentation:** https://docs.ipdata.co/

### Additional APIs (Optional)
The tool is designed to be extensible. You can add API keys for:
- **Shodan** - Security and device information
- **AbuseIPDB** - IP reputation and abuse reports
- **IPGeolocation** - Enhanced geolocation data
- **WHOIS XML API** - Domain registration data

### API Key Configuration
To use premium features, edit the script and add your API keys:

```ruby
# Around line 15-20, add your keys:
SHODAN_API_KEY = "your_shodan_key_here"
ABUSEIPDB_API_KEY = "your_abuseipdb_key_here"
```

---

## 📊 Sample Output Structure

### JSON Export Format
```json
{
  "basic": {
    "query": "8.8.8.8",
    "country": "United States",
    "city": "Mountain View",
    "isp": "Google LLC",
    "lat": 37.386,
    "lon": -122.0838
  },
  "network": {
    "Hostname": "dns.google",
    "PTR Records": "dns.google",
    "A Records": "8.8.8.8, 8.8.4.4"
  },
  "ports": {
    "open": [[53, "DNS"], [443, "HTTPS"]],
    "closed": [[21, "FTP"], [22, "SSH"]]
  },
  "security": {
    "Proxy/VPN": "Not detected",
    "Hosting/Datacenter": "Yes",
    "Port Security": "Low risk (2 open ports)"
  }
}
```

---

## 🛠️ Advanced Configuration

### Custom Port List

Edit the `port_scan` method to add custom ports:

```ruby
common_ports = {
  21 => "FTP",
  22 => "SSH",
  # Add your custom ports here
  8000 => "HTTP-Alt",
  9000 => "Custom-Service"
}
```

### Timeout Adjustment

Modify timeout for port scanning:

```ruby
# In port_scan method, change timeout value:
Timeout::timeout(5) do  # Changed from 2 to 5 seconds
  socket = TCPSocket.new(@target_ip, port)
  socket.close
end
```

### API Key Integration

Add API keys for enhanced features:

```ruby
# At the top of the class:
SHODAN_KEY = ENV['SHODAN_API_KEY'] || "your_key"
ABUSEIPDB_KEY = ENV['ABUSEIPDB_API_KEY'] || "your_key"

# Use in methods:
url = URI("#{API_SOURCES[:shodan]}#{@target_ip}?key=#{SHODAN_KEY}")
```

---

## 📈 Performance Optimization

### Tips for Faster Scanning

1. **Use Quick Lookup for basic needs** - Option 1 is much faster than Deep Analysis
2. **Limit batch size** - Process 10-20 IPs at a time
3. **Skip port scanning** - Unless necessary, as it's time-consuming
4. **Cache results** - Save frequently accessed IPs
5. **Use command line mode** - Faster than interactive menu

### Resource Usage

- **Memory:** ~20-50 MB during execution
- **Network:** ~50-200 KB per IP lookup
- **CPU:** Minimal (mostly I/O bound)
- **Time:** 
  - Quick lookup: 1-3 seconds
  - Deep analysis: 5-10 seconds
  - Port scan: 30-60 seconds
  - Batch (10 IPs): 2-3 minutes

---

## 🔒 Privacy & Security

### Data Handling
- **No data storage:** Results are not saved unless you use the export function
- **No tracking:** The tool does not send any telemetry
- **API privacy:** Review each API's privacy policy before use
- **Local execution:** All processing happens on your device

### Security Best Practices
1. Don't scan IPs without permission
2. Use VPN for privacy when analyzing IPs
3. Don't share API keys in code repositories
4. Be aware of your digital footprint
5. Review and understand the code before running

---

## 🤝 Contributing

Want to improve this tool? Here are some ideas:

- Add support for IPv6 addresses
- Integrate additional API sources
- Implement caching mechanism
- Add GUI interface
- Create mobile app version
- Improve error handling
- Add unit tests
- Support for proxy chains

---

## 📜 License

This tool is provided as-is for educational purposes. Use responsibly and legally.

---

## 👨‍💻 Technical Details

### Dependencies
- **Built-in Ruby libraries:**
  - `net/http` - HTTP requests
  - `json` - JSON parsing
  - `uri` - URI handling
  - `resolv` - DNS resolution
  - `socket` - TCP socket operations
  - `timeout` - Request timeouts
  - `date` - Date/time handling

### Platform Support
- ✅ Linux (All distributions)
- ✅ macOS (10.12+)
- ✅ Windows (with Ruby installed)
- ✅ Android (via Termux)
- ✅ BSD variants
- ✅ ChromeOS (Linux container)

### Ruby Version Compatibility
- Minimum: Ruby 2.5
- Recommended: Ruby 2.7+
- Tested on: Ruby 3.0, 3.1, 3.2

---

## 📞 Support & Contact

### Getting Help
- Read this README thoroughly
- Check Troubleshooting section
- Review error messages carefully
- Test with known-good IPs (8.8.8.8, 1.1.1.1)

### Known Limitations
- Some APIs require registration for full features
- Port scanning may be blocked by firewalls
- WHOIS data limited for IP addresses
- Rate limits on free API tiers
- Some features require internet connection

---

## 🎓 Educational Use Cases

### Network Security Course
- Demonstrate reconnaissance techniques
- Teach network fundamentals
- Show real-world API integration
- Practice Ruby programming

### Cybersecurity Training
- OSINT (Open Source Intelligence) gathering
- Network mapping exercises
- Security assessment methodology
- Ethical hacking fundamentals

### System Administration
- Network troubleshooting
- IP allocation verification
- Geolocation verification
- ISP identification

---

## 🔄 Version History

### Version 2.0 (Current)
- Complete rewrite from v1.0
- Added interactive menu system
- Multiple API integration
- Port scanning capabilities
- WHOIS lookup
- Security analysis
- Batch processing
- Export functionality
- Enhanced error handling
- Color-coded output
- Command-line support

### Version 1.0 (Previous)
- Basic IP lookup
- Simple geolocation
- Single API source
- Limited information

---

## ⚡ Quick Reference Card

```
QUICK COMMANDS:
--------------
Interactive Mode:  ruby ip_recon.rb
Direct Analysis:   ruby ip_recon.rb <IP>
With Debug:        DEBUG=1 ruby ip_recon.rb

COMMON IPs TO TEST:
------------------
Google DNS:      8.8.8.8, 8.8.4.4
Cloudflare DNS:  1.1.1.1, 1.0.0.1
OpenDNS:         208.67.222.222
Quad9:           9.9.9.9

MENU SHORTCUTS:
--------------
1 = Quick Lookup
2 = Deep Analysis
3 = DNS Info
4 = Port Scan (caution!)
10 = My IP
0 = Exit
```

---

## 🌟 Features Comparison

| Feature | Quick Lookup | Deep Analysis | Full Scan |
|---------|-------------|---------------|-----------|
| Basic Info | ✅ | ✅ | ✅ |
| Geolocation | ✅ | ✅ | ✅ |
| ISP Data | ✅ | ✅ | ✅ |
| Multi-API | ❌ | ✅ | ✅ |
| DNS Records | ❌ | ❌ | ✅ |
| Port Scan | ❌ | ❌ | ✅ |
| Security Analysis | Limited | ✅ | ✅ |
| Time Required | 1-3s | 5-10s | 1-2min |

---

**Made with ❤️ for Security Researchers and Network Professionals**

*Remember: With great power comes great responsibility. Use this tool ethically and legally.*

---

## 📚 Additional Resources

### Learning More:
- **Ruby Programming:** https://www.ruby-lang.org/
- **Network Basics:** https://www.cloudflare.com/learning/
- **OSINT Techniques:** https://osintframework.com/
- **Ethical Hacking:** https://www.offensive-security.com/

### Related Tools:
- **nmap** - Network scanner
- **whois** - Domain information
- **dig** - DNS lookup
- **traceroute** - Network path analysis
- **curl** - HTTP requests

---

**Last Updated:** 2024
**Version:** 2.0.0
**Status:** Production Ready

EOF
