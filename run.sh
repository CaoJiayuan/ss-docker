#!/bin/sh
if [ "${HTTP}" == "" ]; then
   export HTTP=true
fi
if [ ${HTTP} == true ]; then
    echo "Run privoxy..."
    privoxy /etc/privoxy/config
fi

echo "Replacing config..."
if [ "${PASSWORD}" == "" ]; then
   export PASSWORD="123456"
fi
if [ "${METHOD}" == "" ]; then
   export METHOD="aes-256-gcm"
fi

if [ "${SERVER}" == "" ]; then
   export SERVER="0.0.0.0"
fi

if [ "${SERVER_PORT}" == "" ]; then
   export SERVER_PORT=8080
fi


envsubst '$PASSWORD,$METHOD,$SERVER,$SERVER_PORT' < ss.json.template > ss.json
if [ "${SERVER}" == "0.0.0.0" ]; then
    echo "Run ss server..."
    /usr/bin/ssserver -c /ss.json
else
    echo "Run ss local..."
    /usr/bin/sslocal -c /ss.json
fi