#!/usr/bin/env ruby
# ============================================================
# Advanced IP Information Reconnaissance Tool
# Version: 2.0
# Description: Comprehensive IP address information gathering
# ============================================================

require 'net/http'
require 'json'
require 'uri'
require 'resolv'
require 'socket'
require 'timeout'
require 'date'
require 'base64'

# Color codes for terminal output
class Colors
  RESET = "\e[0m"
  BOLD = "\e[1m"
  RED = "\e[31m"
  GREEN = "\e[32m"
  YELLOW = "\e[33m"
  BLUE = "\e[34m"
  MAGENTA = "\e[35m"
  CYAN = "\e[36m"
  WHITE = "\e[37m"
  
  def self.colorize(text, color)
    "#{color}#{text}#{RESET}"
  end
end

# Main IP Reconnaissance Class
class IPRecon
  API_SOURCES = {
    ipapi: "http://ip-api.com/json/",
    ipinfo: "https://ipinfo.io/",
    ipdata: "https://api.ipdata.co/",
    ipgeolocation: "https://api.ipgeolocation.io/ipgeo?apiKey=",
    shodan: "https://api.shodan.io/shodan/host/"
  }
  
  attr_reader :target_ip, :data_collection
  
  def initialize(ip = nil)
    @target_ip = ip
    @data_collection = {}
    @start_time = Time.now
  end
  
  # Display banner
  def display_banner
    banner = <<-BANNER
    
#{Colors.colorize("="*70, Colors::CYAN)}
#{Colors.colorize("          ADVANCED IP RECONNAISSANCE TOOL v2.0", Colors::BOLD + Colors::GREEN)}
#{Colors.colorize("              Comprehensive IP Intelligence Gathering", Colors::YELLOW)}
#{Colors.colorize("="*70, Colors::CYAN)}

    BANNER
    puts banner
  end
  
  # Main menu
  def display_menu
    puts "\n#{Colors.colorize("[ MAIN MENU ]", Colors::BOLD + Colors::CYAN)}"
    puts "#{Colors.colorize("="*70, Colors::CYAN)}"
    puts "  1. Quick IP Lookup (Basic Information)"
    puts "  2. Deep IP Analysis (Comprehensive Scan)"
    puts "  3. Network Information & DNS Lookup"
    puts "  4. Port Scanning (Common Ports)"
    puts "  5. WHOIS Information"
    puts "  6. Geolocation & Map Data"
    puts "  7. Security & Threat Analysis"
    puts "  8. Batch IP Lookup (Multiple IPs)"
    puts "  9. Export Results (JSON/TXT)"
    puts "  10. Check My Public IP"
    puts "  0. Exit"
    puts "#{Colors.colorize("="*70, Colors::CYAN)}\n"
  end
  
  # Get user's public IP
  def get_my_public_ip
    begin
      apis = [
        "https://api.ipify.org?format=json",
        "https://api.myip.com",
        "https://ipinfo.io/json"
      ]
      
      apis.each do |api_url|
        begin
          uri = URI(api_url)
          response = Net::HTTP.get_response(uri)
          
          if response.code == "200"
            data = JSON.parse(response.body)
            return data['ip'] || data['query']
          end
        rescue
          next
        end
      end
      
      return nil
    rescue => e
      puts Colors.colorize("Error fetching public IP: #{e.message}", Colors::RED)
      return nil
    end
  end
  
  # Validate IP address format
  def valid_ip?(ip)
    return false if ip.nil? || ip.empty?
    
    # IPv4 validation
    ipv4_regex = /^(\d{1,3}\.){3}\d{1,3}$/
    if ip =~ ipv4_regex
      octets = ip.split('.')
      return octets.all? { |octet| octet.to_i.between?(0, 255) }
    end
    
    # IPv6 validation (basic)
    ipv6_regex = /^([0-9a-fA-F]{0,4}:){7}[0-9a-fA-F]{0,4}$/
    return true if ip =~ ipv6_regex
    
    false
  end
  
  # Quick IP lookup using ip-api.com
  def quick_lookup
    puts "\n#{Colors.colorize("[*] Performing Quick IP Lookup...", Colors::YELLOW)}"
    
    begin
      url = URI("#{API_SOURCES[:ipapi]}#{@target_ip}?fields=66846719")
      response = Net::HTTP.get_response(url)
      
      if response.code == "200"
        data = JSON.parse(response.body)
        
        if data['status'] == 'success'
          @data_collection[:basic] = data
          display_basic_info(data)
          return true
        else
          puts Colors.colorize("[-] Error: #{data['message']}", Colors::RED)
          return false
        end
      else
        puts Colors.colorize("[-] API request failed with status: #{response.code}", Colors::RED)
        return false
      end
    rescue => e
      puts Colors.colorize("[-] Error: #{e.message}", Colors::RED)
      return false
    end
  end
  
  # Display basic IP information
  def display_basic_info(data)
    puts "\n#{Colors.colorize("="*70, Colors::GREEN)}"
    puts Colors.colorize("                    BASIC IP INFORMATION", Colors::BOLD + Colors::GREEN)
    puts Colors.colorize("="*70, Colors::GREEN)
    
    info_table = [
      ["IP Address", data['query']],
      ["Status", data['status']],
      ["Country", "#{data['country']} (#{data['countryCode']})"],
      ["Region", "#{data['regionName']} (#{data['region']})"],
      ["City", data['city']],
      ["ZIP/Postal Code", data['zip']],
      ["Latitude", data['lat']],
      ["Longitude", data['lon']],
      ["Timezone", data['timezone']],
      ["ISP", data['isp']],
      ["Organization", data['org']],
      ["AS Number", data['as']],
      ["Mobile", data['mobile'] ? "Yes" : "No"],
      ["Proxy", data['proxy'] ? "Yes" : "No"],
      ["Hosting", data['hosting'] ? "Yes" : "No"]
    ]
    
    info_table.each do |label, value|
      next if value.nil? || value.to_s.empty?
      puts "  #{Colors.colorize(label.ljust(20), Colors::CYAN)}: #{Colors.colorize(value.to_s, Colors::WHITE)}"
    end
    
    puts Colors.colorize("="*70, Colors::GREEN)
    
    if data['lat'] && data['lon']
      puts "\n#{Colors.colorize("[+]", Colors::GREEN)} Google Maps: https://www.google.com/maps?q=#{data['lat']},#{data['lon']}"
      puts "#{Colors.colorize("[+]", Colors::GREEN)} OpenStreetMap: https://www.openstreetmap.org/?mlat=#{data['lat']}&mlon=#{data['lon']}&zoom=12"
    end
  end
  
  # Deep analysis combining multiple sources
  def deep_analysis
    puts "\n#{Colors.colorize("[*] Initiating Deep IP Analysis...", Colors::YELLOW)}"
    puts Colors.colorize("[*] This may take a few moments...\n", Colors::YELLOW)
    
    # Fetch from multiple sources
    fetch_ipapi_data
    fetch_ipinfo_data
    fetch_ipdata_data
    
    # Display comprehensive results
    display_comprehensive_report
  end
  
  # Fetch data from ip-api.com
  def fetch_ipapi_data
    print "#{Colors.colorize("[*]", Colors::YELLOW)} Fetching from IP-API.com... "
    begin
      url = URI("#{API_SOURCES[:ipapi]}#{@target_ip}?fields=66846719")
      response = Net::HTTP.get_response(url)
      
      if response.code == "200"
        @data_collection[:ipapi] = JSON.parse(response.body)
        puts Colors.colorize("✓", Colors::GREEN)
      else
        puts Colors.colorize("✗", Colors::RED)
      end
    rescue => e
      puts Colors.colorize("✗ (#{e.message})", Colors::RED)
    end
  end
  
  # Fetch data from ipinfo.io
  def fetch_ipinfo_data
    print "#{Colors.colorize("[*]", Colors::YELLOW)} Fetching from IPInfo.io... "
    begin
      url = URI("#{API_SOURCES[:ipinfo]}#{@target_ip}/json")
      response = Net::HTTP.get_response(url)
      
      if response.code == "200"
        @data_collection[:ipinfo] = JSON.parse(response.body)
        puts Colors.colorize("✓", Colors::GREEN)
      else
        puts Colors.colorize("✗", Colors::RED)
      end
    rescue => e
      puts Colors.colorize("✗ (#{e.message})", Colors::RED)
    end
  end
  
  # Fetch data from ipdata.co
  def fetch_ipdata_data
    print "#{Colors.colorize("[*]", Colors::YELLOW)} Fetching from IPData.co... "
    begin
      url = URI("#{API_SOURCES[:ipdata]}#{@target_ip}")
      response = Net::HTTP.get_response(url)
      
      if response.code == "200"
        @data_collection[:ipdata] = JSON.parse(response.body)
        puts Colors.colorize("✓", Colors::GREEN)
      else
        puts Colors.colorize("✗", Colors::RED)
      end
    rescue => e
      puts Colors.colorize("✗ (#{e.message})", Colors::RED)
    end
  end
  
  # Display comprehensive report
  def display_comprehensive_report
    puts "\n#{Colors.colorize("="*70, Colors::GREEN)}"
    puts Colors.colorize("              COMPREHENSIVE IP ANALYSIS REPORT", Colors::BOLD + Colors::GREEN)
    puts Colors.colorize("="*70, Colors::GREEN)
    
    # Combine data from all sources
    combined_data = merge_data_sources
    
    # Display sections
    display_section("GEOGRAPHICAL INFORMATION", combined_data[:geo])
    display_section("NETWORK INFORMATION", combined_data[:network])
    display_section("ORGANIZATION & ISP", combined_data[:org])
    display_section("SECURITY INDICATORS", combined_data[:security])
    display_section("ADDITIONAL DATA", combined_data[:additional])
    
    puts Colors.colorize("="*70, Colors::GREEN)
  end
  
  # Merge data from multiple sources
  def merge_data_sources
    merged = {
      geo: {},
      network: {},
      org: {},
      security: {},
      additional: {}
    }
    
    # Process IP-API data
    if @data_collection[:ipapi]
      data = @data_collection[:ipapi]
      merged[:geo]['Country'] = "#{data['country']} (#{data['countryCode']})"
      merged[:geo]['Region'] = "#{data['regionName']} (#{data['region']})"
      merged[:geo]['City'] = data['city']
      merged[:geo]['ZIP Code'] = data['zip']
      merged[:geo]['Latitude'] = data['lat']
      merged[:geo]['Longitude'] = data['lon']
      merged[:geo]['Timezone'] = data['timezone']
      merged[:geo]['Currency'] = data['currency']
      
      merged[:network]['AS Number'] = data['as']
      merged[:network]['ISP'] = data['isp']
      merged[:org]['Organization'] = data['org']
      
      merged[:security]['Mobile Network'] = data['mobile'] ? 'Yes' : 'No'
      merged[:security]['Proxy'] = data['proxy'] ? 'Yes' : 'No'
      merged[:security]['Hosting/Datacenter'] = data['hosting'] ? 'Yes' : 'No'
    end
    
    # Process IPInfo data
    if @data_collection[:ipinfo]
      data = @data_collection[:ipinfo]
      merged[:geo]['Location (IPInfo)'] ||= data['loc']
      merged[:network]['Hostname'] = data['hostname']
      merged[:org]['Organization (IPInfo)'] ||= data['org']
      merged[:additional]['Postal Code'] = data['postal']
    end
    
    # Process IPData data
    if @data_collection[:ipdata]
      data = @data_collection[:ipdata]
      merged[:geo]['Continent'] = data['continent_name']
      merged[:geo]['Country Code'] = data['country_code']
      merged[:additional]['Calling Code'] = data['calling_code']
      merged[:additional]['Languages'] = data['languages']&.map { |l| l['name'] }&.join(', ')
      merged[:security]['Is EU'] = data['is_eu'] ? 'Yes' : 'No'
      merged[:security]['Threat Level'] = data['threat']&.[]('is_threat') ? 'Detected' : 'None'
    end
    
    merged
  end
  
  # Display a section of information
  def display_section(title, data)
    return if data.nil? || data.empty?
    
    puts "\n#{Colors.colorize("[ #{title} ]", Colors::BOLD + Colors::CYAN)}"
    puts Colors.colorize("-"*70, Colors::CYAN)
    
    data.each do |key, value|
      next if value.nil? || value.to_s.strip.empty?
      puts "  #{Colors.colorize(key.to_s.ljust(25), Colors::YELLOW)}: #{Colors.colorize(value.to_s, Colors::WHITE)}"
    end
  end
  
  # Network information and DNS lookup
  def network_info
    puts "\n#{Colors.colorize("[*] Gathering Network Information...", Colors::YELLOW)}\n"
    
    network_data = {}
    
    # DNS Lookup
    print "#{Colors.colorize("[*]", Colors::YELLOW)} Performing DNS Lookup... "
    begin
      hostname = Resolv.getname(@target_ip)
      network_data['Hostname'] = hostname
      puts Colors.colorize("✓", Colors::GREEN)
    rescue => e
      network_data['Hostname'] = "N/A (#{e.message})"
      puts Colors.colorize("✗", Colors::RED)
    end
    
    # Reverse DNS
    print "#{Colors.colorize("[*]", Colors::YELLOW)} Reverse DNS Lookup... "
    begin
      resolver = Resolv::DNS.new
      ptr_records = resolver.getresources(@target_ip, Resolv::DNS::Resource::IN::PTR)
      if ptr_records.any?
        network_data['PTR Records'] = ptr_records.map(&:name).join(', ')
        puts Colors.colorize("✓", Colors::GREEN)
      else
        network_data['PTR Records'] = "No PTR records found"
        puts Colors.colorize("✗", Colors::RED)
      end
    rescue => e
      network_data['PTR Records'] = "N/A"
      puts Colors.colorize("✗", Colors::RED)
    end
    
    # A Records (if hostname resolved)
    if network_data['Hostname'] && network_data['Hostname'] != "N/A"
      print "#{Colors.colorize("[*]", Colors::YELLOW)} Looking up A Records... "
      begin
        resolver = Resolv::DNS.new
        a_records = resolver.getresources(network_data['Hostname'], Resolv::DNS::Resource::IN::A)
        network_data['A Records'] = a_records.map { |r| r.address.to_s }.join(', ')
        puts Colors.colorize("✓", Colors::GREEN)
      rescue => e
        network_data['A Records'] = "N/A"
        puts Colors.colorize("✗", Colors::RED)
      end
    end
    
    # MX Records
    if network_data['Hostname'] && network_data['Hostname'] != "N/A"
      print "#{Colors.colorize("[*]", Colors::YELLOW)} Looking up MX Records... "
      begin
        domain = network_data['Hostname'].split('.').last(2).join('.')
        resolver = Resolv::DNS.new
        mx_records = resolver.getresources(domain, Resolv::DNS::Resource::IN::MX)
        if mx_records.any?
          network_data['MX Records'] = mx_records.map { |mx| "#{mx.exchange} (#{mx.preference})" }.join(', ')
          puts Colors.colorize("✓", Colors::GREEN)
        else
          network_data['MX Records'] = "No MX records found"
          puts Colors.colorize("✗", Colors::RED)
        end
      rescue => e
        network_data['MX Records'] = "N/A"
        puts Colors.colorize("✗", Colors::RED)
      end
    end
    
    # NS Records
    if network_data['Hostname'] && network_data['Hostname'] != "N/A"
      print "#{Colors.colorize("[*]", Colors::YELLOW)} Looking up NS Records... "
      begin
        domain = network_data['Hostname'].split('.').last(2).join('.')
        resolver = Resolv::DNS.new
        ns_records = resolver.getresources(domain, Resolv::DNS::Resource::IN::NS)
        if ns_records.any?
          network_data['NS Records'] = ns_records.map { |ns| ns.name.to_s }.join(', ')
          puts Colors.colorize("✓", Colors::GREEN)
        else
          network_data['NS Records'] = "No NS records found"
          puts Colors.colorize("✗", Colors::RED)
        end
      rescue => e
        network_data['NS Records'] = "N/A"
        puts Colors.colorize("✗", Colors::RED)
      end
    end
    
    # Display network information
    puts "\n#{Colors.colorize("="*70, Colors::GREEN)}"
    puts Colors.colorize("                NETWORK & DNS INFORMATION", Colors::BOLD + Colors::GREEN)
    puts Colors.colorize("="*70, Colors::GREEN)
    
    network_data.each do |key, value|
      puts "  #{Colors.colorize(key.ljust(20), Colors::CYAN)}: #{Colors.colorize(value.to_s, Colors::WHITE)}"
    end
    
    puts Colors.colorize("="*70, Colors::GREEN)
    
    @data_collection[:network] = network_data
  end
  
  # Port scanning
  def port_scan
    common_ports = {
      21 => "FTP",
      22 => "SSH",
      23 => "Telnet",
      25 => "SMTP",
      53 => "DNS",
      80 => "HTTP",
      110 => "POP3",
      143 => "IMAP",
      443 => "HTTPS",
      445 => "SMB",
      3306 => "MySQL",
      3389 => "RDP",
      5432 => "PostgreSQL",
      5900 => "VNC",
      8080 => "HTTP-Proxy",
      8443 => "HTTPS-Alt"
    }
    
    puts "\n#{Colors.colorize("[*] Scanning Common Ports...", Colors::YELLOW)}"
    puts Colors.colorize("[!] This may take some time...\n", Colors::YELLOW)
    
    open_ports = []
    closed_ports = []
    
    common_ports.each do |port, service|
      print "#{Colors.colorize("[*]", Colors::YELLOW)} Scanning port #{port} (#{service})... "
      
      begin
        Timeout::timeout(2) do
          socket = TCPSocket.new(@target_ip, port)
          socket.close
          open_ports << [port, service]
          puts Colors.colorize("OPEN", Colors::GREEN)
        end
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
        closed_ports << [port, service]
        puts Colors.colorize("CLOSED", Colors::RED)
      rescue => e
        puts Colors.colorize("ERROR", Colors::RED)
      end
    end
    
    # Display results
    puts "\n#{Colors.colorize("="*70, Colors::GREEN)}"
    puts Colors.colorize("                    PORT SCAN RESULTS", Colors::BOLD + Colors::GREEN)
    puts Colors.colorize("="*70, Colors::GREEN)
    
    if open_ports.any?
      puts "\n#{Colors.colorize("[+] Open Ports:", Colors::GREEN)}"
      open_ports.each do |port, service|
        puts "  #{Colors.colorize("Port #{port}", Colors::CYAN)} - #{Colors.colorize(service, Colors::WHITE)}"
      end
    else
      puts "\n#{Colors.colorize("[-] No open ports found", Colors::YELLOW)}"
    end
    
    puts "\n#{Colors.colorize("[*] Total Ports Scanned:", Colors::CYAN)} #{common_ports.size}"
    puts "#{Colors.colorize("[+] Open Ports:", Colors::GREEN)} #{open_ports.size}"
    puts "#{Colors.colorize("[-] Closed Ports:", Colors::RED)} #{closed_ports.size}"
    
    puts Colors.colorize("="*70, Colors::GREEN)
    
    @data_collection[:ports] = { open: open_ports, closed: closed_ports }
  end
  
  # WHOIS lookup simulation (basic)
  def whois_lookup
    puts "\n#{Colors.colorize("[*] Performing WHOIS Lookup...", Colors::YELLOW)}"
    
    begin
      # Using a WHOIS API
      url = URI("https://www.whoisxmlapi.com/whoisserver/WhoisService?apiKey=at_free&domainName=#{@target_ip}&outputFormat=JSON")
      response = Net::HTTP.get_response(url)
      
      if response.code == "200"
        data = JSON.parse(response.body)
        
        puts "\n#{Colors.colorize("="*70, Colors::GREEN)}"
        puts Colors.colorize("                    WHOIS INFORMATION", Colors::BOLD + Colors::GREEN)
        puts Colors.colorize("="*70, Colors::GREEN)
        
        if data['WhoisRecord']
          whois_data = data['WhoisRecord']
          
          info = {
            'Domain Name' => whois_data['domainName'],
            'Registrar' => whois_data['registrarName'],
            'Created Date' => whois_data['createdDate'],
            'Updated Date' => whois_data['updatedDate'],
            'Expires Date' => whois_data['expiresDate'],
            'Status' => whois_data['status']
          }
          
          info.each do |key, value|
            next if value.nil?
            puts "  #{Colors.colorize(key.ljust(20), Colors::CYAN)}: #{Colors.colorize(value.to_s, Colors::WHITE)}"
          end
        else
          puts Colors.colorize("  [!] WHOIS data not available for this IP", Colors::YELLOW)
        end
        
        puts Colors.colorize("="*70, Colors::GREEN)
      else
        puts Colors.colorize("[-] WHOIS lookup failed", Colors::RED)
      end
    rescue => e
      puts Colors.colorize("[-] Error: #{e.message}", Colors::RED)
      puts Colors.colorize("[*] Note: WHOIS data is limited for IP addresses. Try with a domain name.", Colors::YELLOW)
    end
  end
  
  # Geolocation and mapping
  def geolocation_info
    puts "\n#{Colors.colorize("[*] Gathering Geolocation Data...", Colors::YELLOW)}\n"
    
    quick_lookup unless @data_collection[:basic]
    
    if @data_collection[:basic]
      data = @data_collection[:basic]
      
      puts "\n#{Colors.colorize("="*70, Colors::GREEN)}"
      puts Colors.colorize("               GEOLOCATION & MAP INFORMATION", Colors::BOLD + Colors::GREEN)
      puts Colors.colorize("="*70, Colors::GREEN)
      
      puts "\n#{Colors.colorize("[+] Geographic Coordinates:", Colors::GREEN)}"
      puts "  Latitude  : #{Colors.colorize(data['lat'].to_s, Colors::WHITE)}"
      puts "  Longitude : #{Colors.colorize(data['lon'].to_s, Colors::WHITE)}"
      
      puts "\n#{Colors.colorize("[+] Location Details:", Colors::GREEN)}"
      puts "  Country   : #{Colors.colorize(data['country'], Colors::WHITE)}"
      puts "  Region    : #{Colors.colorize(data['regionName'], Colors::WHITE)}"
      puts "  City      : #{Colors.colorize(data['city'], Colors::WHITE)}"
      puts "  ZIP Code  : #{Colors.colorize(data['zip'], Colors::WHITE)}"
      puts "  Timezone  : #{Colors.colorize(data['timezone'], Colors::WHITE)}"
      
      puts "\n#{Colors.colorize("[+] Map Links:", Colors::GREEN)}"
      puts "  Google Maps     : https://www.google.com/maps?q=#{data['lat']},#{data['lon']}"
      puts "  OpenStreetMap   : https://www.openstreetmap.org/?mlat=#{data['lat']}&mlon=#{data['lon']}&zoom=12"
      puts "  Bing Maps       : https://www.bing.com/maps?cp=#{data['lat']}~#{data['lon']}&lvl=12"
      
      puts Colors.colorize("="*70, Colors::GREEN)
    else
      puts Colors.colorize("[-] Unable to fetch geolocation data", Colors::RED)
    end
  end
  
  # Security and threat analysis
  def security_analysis
    puts "\n#{Colors.colorize("[*] Performing Security Analysis...", Colors::YELLOW)}\n"
    
    security_data = {}
    
    # Check if IP is in known blacklists (using API)
    print "#{Colors.colorize("[*]", Colors::YELLOW)} Checking IP reputation... "
    begin
      url = URI("https://api.abuseipdb.com/api/v2/check?ipAddress=#{@target_ip}")
      
      # Note: This requires an API key, so we'll simulate
      security_data['Blacklist Status'] = "Not checked (API key required)"
      puts Colors.colorize("⚠", Colors::YELLOW)
    rescue => e
      security_data['Blacklist Status'] = "Error checking"
      puts Colors.colorize("✗", Colors::RED)
    end
    
    # Check if it's a known proxy/VPN
    if @data_collection[:basic]
      security_data['Proxy/VPN'] = @data_collection[:basic]['proxy'] ? 'Detected' : 'Not detected'
      security_data['Mobile Network'] = @data_collection[:basic]['mobile'] ? 'Yes' : 'No'
      security_data['Hosting/Datacenter'] = @data_collection[:basic]['hosting'] ? 'Yes' : 'No'
    end
    
    # Check if ports are open (security risk)
    if @data_collection[:ports] && @data_collection[:ports][:open]
      open_count = @data_collection[:ports][:open].size
      if open_count > 5
        security_data['Port Security'] = "High risk (#{open_count} open ports)"
      elsif open_count > 2
        security_data['Port Security'] = "Medium risk (#{open_count} open ports)"
      elsif open_count > 0
        security_data['Port Security'] = "Low risk (#{open_count} open ports)"
      else
        security_data['Port Security'] = "Good (no open ports detected)"
      end
    end
    
    # Display security analysis
    puts "\n#{Colors.colorize("="*70, Colors::GREEN)}"
    puts Colors.colorize("              SECURITY & THREAT ANALYSIS", Colors::BOLD + Colors::GREEN)
    puts Colors.colorize("="*70, Colors::GREEN)
    
    security_data.each do |key, value|
      color = value.include?('High') || value.include?('Detected') ? Colors::RED : 
              value.include?('Medium') ? Colors::YELLOW : Colors::GREEN
      puts "  #{Colors.colorize(key.ljust(25), Colors::CYAN)}: #{Colors.colorize(value.to_s, color)}"
    end
    
    puts "\n#{Colors.colorize("[!] Security Recommendations:", Colors::YELLOW)}"
    puts "  - Always verify the legitimacy of suspicious IPs"
    puts "  - Use VPN for sensitive operations"
    puts "  - Keep firewall and antivirus updated"
    puts "  - Monitor unusual network activity"
    
    puts Colors.colorize("="*70, Colors::GREEN)
    
    @data_collection[:security] = security_data
  end
  
  # Batch IP lookup
  def batch_lookup
    puts "\n#{Colors.colorize("[*] Batch IP Lookup Mode", Colors::YELLOW)}"
    puts "Enter IP addresses (one per line, empty line to finish):\n"
    
    ips = []
    loop do
      print "IP #{ips.size + 1}: "
      ip = gets.chomp
      break if ip.empty?
      
      if valid_ip?(ip)
        ips << ip
      else
        puts Colors.colorize("[-] Invalid IP format, skipped", Colors::RED)
      end
    end
    
    return if ips.empty?
    
    puts "\n#{Colors.colorize("[*] Processing #{ips.size} IP addresses...", Colors::YELLOW)}\n"
    
    results = []
    
    ips.each_with_index do |ip, index|
      puts "\n#{Colors.colorize("="*70, Colors::CYAN)}"
      puts Colors.colorize("[#{index + 1}/#{ips.size}] Analyzing: #{ip}", Colors::BOLD + Colors::CYAN)
      puts Colors.colorize("="*70, Colors::CYAN)
      
      recon = IPRecon.new(ip)
      if recon.quick_lookup
        results << { ip: ip, status: 'success', data: recon.data_collection[:basic] }
      else
        results << { ip: ip, status: 'failed' }
      end
      
      sleep(1) # Rate limiting
    end
    
    # Summary
    puts "\n#{Colors.colorize("="*70, Colors::GREEN)}"
    puts Colors.colorize("                  BATCH LOOKUP SUMMARY", Colors::BOLD + Colors::GREEN)
    puts Colors.colorize("="*70, Colors::GREEN)
    puts "Total IPs processed: #{ips.size}"
    puts "Successful lookups: #{results.count { |r| r[:status] == 'success' }}"
    puts "Failed lookups: #{results.count { |r| r[:status] == 'failed' }}"
    puts Colors.colorize("="*70, Colors::GREEN)
    
    @data_collection[:batch] = results
  end
  
  # Export results
  def export_results
    puts "\n#{Colors.colorize("[*] Export Results", Colors::YELLOW)}"
    puts "1. Export as JSON"
    puts "2. Export as TXT"
    puts "3. Cancel"
    print "\nSelect option: "
    
    choice = gets.chomp
    
    timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
    filename_base = "ip_recon_#{@target_ip}_#{timestamp}"
    
    case choice
    when "1"
      filename = "#{filename_base}.json"
      File.write(filename, JSON.pretty_generate(@data_collection))
      puts Colors.colorize("[+] Results exported to: #{filename}", Colors::GREEN)
    when "2"
      filename = "#{filename_base}.txt"
      File.open(filename, 'w') do |f|
        f.puts "="*70
        f.puts "IP RECONNAISSANCE REPORT"
        f.puts "Target: #{@target_ip}"
        f.puts "Generated: #{Time.now}"
        f.puts "="*70
        f.puts "\n"
        f.puts JSON.pretty_generate(@data_collection)
      end
      puts Colors.colorize("[+] Results exported to: #{filename}", Colors::GREEN)
    else
      puts Colors.colorize("[-] Export cancelled", Colors::YELLOW)
    end
  end
  
  # Main execution loop
  def run
    display_banner
    
    loop do
      display_menu
      print "#{Colors.colorize("└─>", Colors::GREEN)} Select option: "
      choice = gets.chomp
      
      case choice
      when "1"
        if @target_ip.nil? || @target_ip.empty?
          print "Enter target IP: "
          @target_ip = gets.chomp
        end
        
        if valid_ip?(@target_ip)
          quick_lookup
        else
          puts Colors.colorize("[-] Invalid IP address format", Colors::RED)
          @target_ip = nil
        end
        
      when "2"
        if @target_ip.nil? || @target_ip.empty?
          print "Enter target IP: "
          @target_ip = gets.chomp
        end
        
        if valid_ip?(@target_ip)
          deep_analysis
        else
          puts Colors.colorize("[-] Invalid IP address format", Colors::RED)
          @target_ip = nil
        end
        
      when "3"
        if @target_ip.nil? || @target_ip.empty?
          print "Enter target IP: "
          @target_ip = gets.chomp
        end
        
        if valid_ip?(@target_ip)
          network_info
        else
          puts Colors.colorize("[-] Invalid IP address format", Colors::RED)
          @target_ip = nil
        end
        
      when "4"
        if @target_ip.nil? || @target_ip.empty?
          print "Enter target IP: "
          @target_ip = gets.chomp
        end
        
        if valid_ip?(@target_ip)
          puts Colors.colorize("\n[!] WARNING: Port scanning may be illegal in some jurisdictions.", Colors::YELLOW)
          puts Colors.colorize("[!] Only scan IPs you own or have permission to test.", Colors::YELLOW)
          print "\nContinue? (yes/no): "
          confirm = gets.chomp.downcase
          
          if confirm == 'yes' || confirm == 'y'
            port_scan
          else
            puts Colors.colorize("[-] Port scan cancelled", Colors::YELLOW)
          end
        else
          puts Colors.colorize("[-] Invalid IP address format", Colors::RED)
          @target_ip = nil
        end
        
      when "5"
        if @target_ip.nil? || @target_ip.empty?
          print "Enter target IP or domain: "
          @target_ip = gets.chomp
        end
        whois_lookup
        
      when "6"
        if @target_ip.nil? || @target_ip.empty?
          print "Enter target IP: "
          @target_ip = gets.chomp
        end
        
        if valid_ip?(@target_ip)
          geolocation_info
        else
          puts Colors.colorize("[-] Invalid IP address format", Colors::RED)
          @target_ip = nil
        end
        
      when "7"
        if @target_ip.nil? || @target_ip.empty?
          print "Enter target IP: "
          @target_ip = gets.chomp
        end
        
        if valid_ip?(@target_ip)
          security_analysis
        else
          puts Colors.colorize("[-] Invalid IP address format", Colors::RED)
          @target_ip = nil
        end
        
      when "8"
        batch_lookup
        
      when "9"
        if @data_collection.empty?
          puts Colors.colorize("[-] No data to export. Run a scan first.", Colors::RED)
        else
          export_results
        end
        
      when "10"
        puts "\n#{Colors.colorize("[*] Fetching your public IP...", Colors::YELLOW)}"
        my_ip = get_my_public_ip
        
        if my_ip
          puts Colors.colorize("[+] Your public IP: #{my_ip}", Colors::GREEN)
          print "\nAnalyze this IP? (yes/no): "
          confirm = gets.chomp.downcase
          
          if confirm == 'yes' || confirm == 'y'
            @target_ip = my_ip
            deep_analysis
          end
        else
          puts Colors.colorize("[-] Unable to fetch public IP", Colors::RED)
        end
        
      when "0"
        elapsed_time = Time.now - @start_time
        puts "\n#{Colors.colorize("="*70, Colors::CYAN)}"
        puts Colors.colorize("  Session Duration: #{elapsed_time.round(2)} seconds", Colors::YELLOW)
        puts Colors.colorize("  Thank you for using IP Recon Tool!", Colors::GREEN)
        puts Colors.colorize("="*70, Colors::CYAN)
        exit(0)
        
      else
        puts Colors.colorize("[-] Invalid option. Please try again.", Colors::RED)
      end
      
      puts "\n#{Colors.colorize("Press Enter to continue...", Colors::YELLOW)}"
      gets
    end
  end
end

# ============================================================
# Program Entry Point
# ============================================================

if __FILE__ == $0
  begin
    # Check if IP provided as command line argument
    if ARGV.any?
      ip = ARGV[0]
      recon = IPRecon.new(ip)
      
      if recon.valid_ip?(ip)
        recon.display_banner
        puts Colors.colorize("[*] Target IP: #{ip}", Colors::CYAN)
        recon.deep_analysis
        recon.network_info
        recon.security_analysis
      else
        puts Colors.colorize("[-] Invalid IP address format", Colors::RED)
        puts "Usage: ruby ip_recon.rb [IP_ADDRESS]"
      end
    else
      # Interactive mode
      recon = IPRecon.new
      recon.run
    end
    
  rescue Interrupt
    puts "\n\n#{Colors.colorize("[!] Program interrupted by user", Colors::YELLOW)}"
    exit(0)
  rescue => e
    puts Colors.colorize("\n[!] Fatal Error: #{e.message}", Colors::RED)
    puts e.backtrace if ENV['DEBUG']
    exit(1)
  end
end
