#!/bin/sh
echo "Run privoxy..."
privoxy /etc/privoxy/config
echo "Replacing config..."
if [ "${PASSWORD}" == "" ]; then
   export PASSWORD="123456"
fi
if [ "${METHOD}" == "" ]; then
   export METHOD="aes-256-gcm"
fi

envsubst '$PASSWORD,$METHOD' < ss.json.template > ss.json
echo "Run ss server..."
/usr/bin/ssserver -c /ss.json