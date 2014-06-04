#!/usr/bin/env ruby

begin
  require 'csv'
  require 'trollop'
rescue LoadError => e
  puts "think you've got a gem problem old boy: #{e}"
  puts "Run bundle install"
  exit 1
end

@opts = Trollop::options do
  opt :input_file, "Nessus CSV input file", :type => :string, :required => true
  opt :output_file, "Output CSV file", :type => :string, :required => true
  opt :cvss, "Minumum CVSS score", :type => :integer, :default => 7
  opt :verbose, "Be verbose"
end

def log(message)
  puts "[*] #{message}" if @opts[:verbose]
end

log("Processing file #{@opts[:input_file]}")
log("Minimum CVSS: #{@opts[:cvss]}")
csv = CSV.parse(File.read(@opts[:input_file]), :headers => true, :header_converters => :symbol)

hosts_vulns = { 'IP Address' => [] }

csv.each do |row|
  unless row[:cvss].to_i < @opts[:cvss]

    # Build a list of IP address
    hosts_vulns['IP Address'] |= [row[:host]]

    # combine vulnerability name with CVE if available
    vuln_title = "#{row[:name]} (#{row[:cve]})" unless row[:cve].empty?
    vuln_title = vuln_title || row[:name]

    if hosts_vulns.key?(vuln_title)
      log("Adding host #{row[:host]} to new vulnerability: #{row[:host]}")
      hosts_vulns[vuln_title] << row[:host]
    else
      log("Adding host #{row[:host]} to vulnerability #{hosts_vulns[vuln_title]}")
      hosts_vulns[vuln_title] = [row[:host]]
    end
  end
end

# Now we generate our new CSV - this is the header row
csv_output = [ hosts_vulns.keys ]

# # The vulns go on the top row with a blank first column
hosts_vulns['IP Address'].each do |ip|
  host_row = [ ip ]
  hosts_vulns.keys.each do |vuln|
    # skip the IP Address column
    next if vuln == 'IP Address'

    log("Processing vulnerability #{vuln}")

    if hosts_vulns[vuln].include?(ip)
      host_row << "X"
    else
      host_row << ""
    end
  end

  # Append our new row to the output array
  csv_output << host_row
end

# Now write to a file
log("Writing output to #{@opts[:output_file]}")
CSV.open(@opts[:output_file], 'wb') do |csv_file|
  csv_output.each do |row|
    csv_file  << row
  end
end

log("Completed")






