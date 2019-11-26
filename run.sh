#!/usr/bin/env bashio
set -e

# Get options
CONFIG_PATH=/data/options.json
NGROK_AUTH=$(jq --raw-output ".NGROK_AUTH" $CONFIG_PATH)
NGROK_SUBDOMAIN=$(jq --raw-output ".NGROK_SUBDOMAIN" $CONFIG_PATH)
NGROK_HOSTNAME=$(jq --raw-output ".NGROK_HOSTNAME" $CONFIG_PATH)
NGROK_REGION=$(jq --raw-output ".NGROK_REGION" $CONFIG_PATH)
NGROK_INSPECT=$(jq --raw-output ".NGROK_INSPECT" $CONFIG_PATH)
PORT_80=$(jq --raw-output ".PORT_80" $CONFIG_PATH)
PORT_443=$(jq --raw-output ".PORT_443" $CONFIG_PATH)
PORT_8123=$(jq --raw-output ".PORT_8123" $CONFIG_PATH)

# Create a new config file.
echo "web_addr: 0.0.0.0:4040" > ~/.ngrok2/ngrok.yml

# Set custom domain and check for authentication token.
DOMAIN=null
if [ -n "$NGROK_HOSTNAME" ] && [ -n "$NGROK_AUTH" ]; then
  DOMAIN="hostname: $NGROK_HOSTNAME"
elif [ -n "$NGROK_SUBDOMAIN" ] && [ -n "$NGROK_AUTH" ]; then
  DOMAIN="subdomain: $NGROK_SUBDOMAIN"
elif [ -n "$NGROK_HOSTNAME" ] || [ -n "$NGROK_SUBDOMAIN" ]; then
  if [ -z "$NGROK_AUTH" ]; then
    echo "You must specify an authentication token after registering at https://ngrok.com to use custom domains."
    exit 1
  fi
fi

# Set authentication token
if [ -n "$NGROK_AUTH" ]; then
  echo "authtoken: $NGROK_AUTH" >> ~/.ngrok2/ngrok.yml
fi

# Set region
if [ -n "$NGROK_REGION"]; then
  echo "region: $NGROK_REGION" >> ~/.ngrok2/ngrok.yml
fi

# Define tunnels
if [![ $PORT_80 ] && ![ $PORT_443 ] && ![ $PORT_8123 ]]; then
  echo "You must specify at least one port to forward."
  exit 1
fi
echo "tunnels:" >> ~/.ngrok2/ngrok.yml
if [$PORT_80]; then
  echo "  http-80:" >> ~/.ngrok2/ngrok.yml
  echo "    proto: http" >> ~/.ngrok2/ngrok.yml
  echo "    addr: 127.0.0.1:80" >> ~/.ngrok2/ngrok.yml
  if [ -n $DOMAIN ]; then
    echo "    $DOMAIN" >> ~/.ngrok2/ngrok.yml
  fi
  echo "    bind-tls: false" >> ~/.ngrok2/ngrok.yml
  echo "    inspect: $NGROK_INSPECT" >> ~/.ngrok2/ngrok.yml
fi

if [$PORT_443]; then
  echo "  tls-443:" >> ~/.ngrok2/ngrok.yml
  echo "    proto: tls" >> ~/.ngrok2/ngrok.yml
  echo "    addr: 127.0.0.1:443" >> ~/.ngrok2/ngrok.yml
  if [ -n $DOMAIN ]; then
    echo "    $DOMAIN" >> ~/.ngrok2/ngrok.yml
  fi
  echo "    inspect: $NGROK_INSPECT" >> ~/.ngrok2/ngrok.yml
fi

if [$PORT_8123]; then
  echo "  http-8123:" >> ~/.ngrok2/ngrok.yml
  echo "    proto: http" >> ~/.ngrok2/ngrok.yml
  echo "    addr: 127.0.0.1:8123" >> ~/.ngrok2/ngrok.yml
  if [ -n $DOMAIN ]; then
    echo "    $DOMAIN" >> ~/.ngrok2/ngrok.yml
  fi
  echo "    bind-tls: both" >> ~/.ngrok2/ngrok.yml
  echo "    inspect: $NGROK_INSPECT" >> ~/.ngrok2/ngrok.yml
fi

ngrok start