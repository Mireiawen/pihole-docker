#!/bin/bash
# Lookups may not work for VPN / tun0
IP_LOOKUP="$(ip route get 8.8.8.8 | awk '{ print $NF; exit }')"  
IPv6_LOOKUP="$(ip -6 route get 2001:4860:4860::8888 | awk '{for(i=1;i<=NF;i++) if ($i=="src") print $(i+1)}')"  

# Just hard code these to your docker server's LAN IP if lookups aren't working
IP="${IP:-$IP_LOOKUP}"  # use $IP, if set, otherwise IP_LOOKUP
IPv6="${IPv6:-$IPv6_LOOKUP}"  # use $IPv6, if set, otherwise IP_LOOKUP

echo -e "### Make sure your IPs are correct, hard code ServerIP ENV VARs if necessary\nIP: ${IP}\nIPv6: ${IPv6}"

# Default ports + daemonized docker container
docker run --detach \
	--name 'pihole' \
	--publish '53:53/tcp' -p '53:53/udp' \
	--publish '67:67/udp' \
	--publish '80:80' \
	--publish '443:443' \
	--volume "pihole_etc:/etc/pihole/" \
	--volume "pihole_dnsmasqd:/etc/dnsmasq.d/" \
	--env ServerIP="${IP}" \
	--env ServerIPv6="${IPv6}" \
	--restart='unless-stopped' \
	--cap-add='NET_ADMIN' \
	--dns='127.0.0.1' --dns='1.1.1.1' \
	'mireiawen/pihole:latest'

sleep '3s'
echo -n "Your password for http://${IP}/admin/ is "
docker logs 'pihole' 2> '/dev/null' |grep 'password:'
