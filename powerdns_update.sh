#!/bin/bash

#LISTEN_INTERFACE="{{ your_dynamic_changed_ip_interface_name }}"
#DYNDNS_NAME="{{ your_public_dns_host_name }}"
#POWERDNS_API_KEY="{{ your_powerdns_api_key }}"
#POWERDNS_SERVER="{{ your_powerdns_server_name }}"
#DOMAIN="{{ your_domain_to_update }}"

LISTEN_INTERFACE="pppoe-wan2"
DYNDNS_NAME="isp2.core-wrt-01.woinc.ru"
POWERDNS_API_KEY="as16zzzzzRt2f2r31q1bUP44h29h6999"
POWERDNS_SERVER="consul1.woinc.space"
DOMAIN="woinc.ru"

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}


isp_get_ip=`ifconfig ${LISTEN_INTERFACE} | grep addr | awk -F ":" '{print $2}' | awk -F "P" '{print $1}'| sed 's/ *$//'`

if [ -z "$isp_get_ip" ]; then

	  echo "ISP not works, interface no have a public IP"
	  exit 1;

else
	
    if valid_ip $isp_get_ip; then

		  echo "ISP looks like estabilished, up, and interface have a public IP"
		  echo "Try to update dynamic DNS record"
    
      rm -f replace.json
		
      echo '{"rrsets": [ {"name": "'${DYNDNS_NAME}'.", "type": "A", "ttl": 60, "changetype": "REPLACE", "records": [ {"content": "'$isp_get_ip'", "disabled": false } ] } ] }' >> replace.json
    
      curl -X PATCH --data @replace.json -H "X-API-Key: ${POWERDNS_API_KEY}" http://${POWERDNS_SERVER}:8081/api/v1/servers/localhost/zones/${DOMAIN}
		
      echo "Done dynamic update"
		
      exit 0;
	
  else
		  
      echo "Interface presented but no have a valid IP address"
		
      exit 1;
	
  fi

fi
