#!/bin/bash

### get arguments
while getopts d:a:i: option
do
case "${option}"
in
a) TOKEN=${OPTARG};;
d) domain_name=${OPTARG};;
i) IP=${OPTARG};;
esac
done

if [ "$TOKEN" == "" ] || [ "$domain_name" == "" ]; then
        echo "API key and domain name are required"
        exit 1
fi


root_domain=$(echo $domain_name | awk -F\. '{print $(NF-1) FS $NF}' )

###check if its a root domain ro subdomain
if [ "$(echo $domain_name | awk -F"." '{print $3}')" == "" ] ; then
        subdomain="@"
else
        subdomain=$(echo $domain_name | awk -F"." '{print $1}')
fi

### get current IP From Arvancloud DNS
data=$(curl -s -L -X GET \
   "https://napi.arvancloud.ir/cdn/4.0/domains/$root_domain/dns-records" \
   -H "Content-Type: application/json" \
   -H "Accept: application/json" \
   -H "Authorization: ${TOKEN}")
current_IP=$(echo $data | jq '.data[] | select(.type=="a") |  select(.name=="'$subdomain'") ' | jq '.value[].ip' 2> /dev/null  | sed 's/^"\(.*\)".*/\1/')
domain_id=$(echo $data |  jq '.data[] | select(.type=="a")   |  select(.name=="'$subdomain'") ' | jq '.id' 2> /dev/null | sed 's/^"\(.*\)".*/\1/' )

    if [ "${domain_id}" != "" ]; then
            PutNewIP=$(curl -s -L -X PUT "https://napi.arvancloud.ir/cdn/4.0/domains/$root_domain/dns-records/$domain_id" \
       -H "Content-Type: application/json" \
       -H "Accept: application/json" \
       -H "Authorization: ${TOKEN}" \
       -d "{ \"name\": \"$subdomain\", \"type\": \"a\", \"value\": [$IP]}")
   else
       PutNewIP=$(curl -s -L -X POST "https://napi.arvancloud.ir/cdn/4.0/domains/$root_domain/dns-records/" \
       -H "Content-Type: application/json" \
       -H "Accept: application/json" \
       -H "Authorization: ${TOKEN}" \
       -d "{ \"name\": \"$subdomain\", \"type\": \"a\", \"value\": [$IP]}")
   fi
echo $PutNewIP
