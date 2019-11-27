#!/usr/bin/env bashio
set -e

CONFIG_PATH=/data/options.json
NGROK_AUTH=$(jq --raw-output ".NGROK_AUTH" $CONFIG_PATH)
NGROK_SUBDOMAIN=$(jq --raw-output ".NGROK_SUBDOMAIN" $CONFIG_PATH)
NGROK_HOSTNAME=$(jq --raw-output ".NGROK_HOSTNAME" $CONFIG_PATH)
NGROK_REGION=$(jq --raw-output ".NGROK_REGION" $CONFIG_PATH)
NGROK_INSPECT=$(jq --raw-output ".NGROK_INSPECT" $CONFIG_PATH)
PORT_80=$(jq --raw-output ".PORT_80" $CONFIG_PATH)
PORT_443=$(jq --raw-output ".PORT_443" $CONFIG_PATH)

echo "web_addr: 0.0.0.0:4040" > /ngrok-config/ngrok.yml

DOMAIN=""
if [ -n "$NGROK_HOSTNAME" ] && [ -n "$NGROK_AUTH" ]; then
  DOMAIN="hostname: \"$NGROK_HOSTNAME\""
elif [ -n "$NGROK_SUBDOMAIN" ] && [ -n "$NGROK_AUTH" ]; then
  DOMAIN="subdomain: \"$NGROK_SUBDOMAIN\""
elif [ -n "$NGROK_HOSTNAME" ] || [ -n "$NGROK_SUBDOMAIN" ]; then
  if [ -z "$NGROK_AUTH" ]; then
    echo "You must specify an authentication token after registering at https://ngrok.com to use custom domains."
    exit 1
  fi
fi

if [ -n "$NGROK_AUTH" ]; then
  echo "authtoken: $NGROK_AUTH" >> /ngrok-config/ngrok.yml
fi

echo "region: $NGROK_REGION" >> /ngrok-config/ngrok.yml

if [ "$PORT_443" == true && -z "$NGROK_AUTH" ]; then
  echo "Can't use tls tunnels without an authentication token and a paid account."
  $PORT_443=false
fi

if [ "$PORT_80" == false && "$PORT_443" == false ]; then
  echo "You must specify at least one port to forward."
  exit 1
fi
echo "tunnels:" >> /ngrok-config/ngrok.yml
if [ "$PORT_80" == true ]; then
  echo "  http-80:" >> /ngrok-config/ngrok.yml
  echo "    proto: http" >> /ngrok-config/ngrok.yml
  echo "    addr: 80" >> /ngrok-config/ngrok.yml
  if [ -n "$DOMAIN" ]; then
    echo "    $DOMAIN" >> /ngrok-config/ngrok.yml
  fi
  echo "    bind-tls: false" >> /ngrok-config/ngrok.yml
  echo "    inspect: $NGROK_INSPECT" >> /ngrok-config/ngrok.yml
fi

if [ "$PORT_443" == true ]; then
  echo "  tls-443:" >> /ngrok-config/ngrok.yml
  echo "    proto: tls" >> /ngrok-config/ngrok.yml
  echo "    addr: 443" >> /ngrok-config/ngrok.yml
  if [ -n "$DOMAIN" ]; then
    echo "    $DOMAIN" >> /ngrok-config/ngrok.yml
  fi
  echo "    inspect: $NGROK_INSPECT" >> /ngrok-config/ngrok.yml
fi

echo "Current config:"
cat /ngrok-config/ngrok.yml
echo ""

ngrok start --config /ngrok-config/ngrok.yml --all &
