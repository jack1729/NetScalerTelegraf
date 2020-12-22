#!/bin/bash
#
# Invoke: sh ns_rest_query.sh <IP or  hostname> <API-Operation> <readonlyusername> <readonlypassword>
# Example: sh ns_rest_query.sh w.x.y.z tbd telegraf telegraf
#
 
# Pipe bash arguments to variables
ns=$1
operation=$2
user=$3
pass=$4
 
# Create random cookie filename to avoid race conditions by multiple, concurrent script executions
cookiefilename=ns_cookie_$RANDOM
 
# ns Login and store session cookie to /etc/telegraf
curl -s -k -d "<username=$user password=$pass/>" -c /etc/telegraf/$cookiefilename -X POST https://$ns/nitro/v1/config/login > /dev/null
 
# APIC Query Operation using the session cookie
curl -s -k -X GET https://$ns/$operation -b /etc/telegraf/$cookiefilename
 
# APIC Logout
curl -s -k -d "<aaaUser name=$user/>" -X POST https://$apic/api/mo/aaaLogout.json -b /etc/telegraf/$cookiefilename > /dev/null
 
# Remove session cookie
rm /etc/telegraf/$cookiefilename
