!/bin/bash
#
# This script checks the external IP address of my host that is behind a NAT server
# It also compares with the registered DDNS IP
#
# Resolve the IP of your DDNS hostname (e.g. my_server - you must change to the correct URL)
ddns_ip=$(dig +short my_server.ddns.net)

# Get your current public IPv4 from ifconfig.me
public_ip=$(curl -4 -s ifconfig.me)

echo "IPv4 (ifconfig.me): $public_ip"
echo "IPv6 (ifconfig.me): $(curl -6 -s ifconfig.me)"

# Compare them
echo "DDNS resolves to: $ddns_ip"

if [ "$ddns_ip" = "$public_ip" ]; then
  echo "✅ Current IP match with DNS"
else
  echo "❌ Current IP differ from DNS"
fi