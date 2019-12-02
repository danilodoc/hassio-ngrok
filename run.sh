#!/usr/bin/env bashio
set -e
mkdir -p /ngrok-config

if [[ -f /share/ngrok.yml ]]; then
  echo "Starting ngrok using config file found at $configFile"
  cp $configFile /ngrok-config/ngrok.yml
else

  CONFIG_PATH=/data/options.json
  auth_token=$(jq --raw-output ".auth_token" $CONFIG_PATH)
  region=$(jq --raw-output ".region" $CONFIG_PATH)
  port=$(jq --raw-output ".port" $CONFIG_PATH)
  inspect=$(jq --raw-output ".inspect" $CONFIG_PATH)
  subdomain=$(jq --raw-output ".subdomain" $CONFIG_PATH)
  hostname=$(jq --raw-output ".hostname" $CONFIG_PATH)
  use_tls=$(jq --raw-output ".use_tls" $CONFIG_PATH)

  echo "web_addr: 0.0.0.0:4040" > /ngrok-config/ngrok.yml
  if [ -n "$auth_token" ]; then
    echo "authtoken: $auth_token" >> /ngrok-config/ngrok.yml
  fi
  if [ -n "$region" ]; then
    echo "region: $region" >> /ngrok-config/ngrok.yml
  else
    echo "No region defined, default region is US."
  fi
  echo "tunnels:" >> /ngrok-config/ngrok.yml
  echo "  home-assistant:" >> /ngrok-config/ngrok.yml
  if [ $use_tls ]; then
    echo "    proto: tls" >> /ngrok-config/ngrok.yml
  else 
    echo "    proto: http" >> /ngrok-config/ngrok.yml
    if [ -n $inspect ]; then
      echo "    inspect: $inspect" >> /ngrok-config/ngrok.yml
    fi
  fi
  if [ -n "$port" ]; then
    echo "    172.30.32.2:$port" >> /ngrok-config/ngrok.yml
  else
    echo "You must specify a port!"
    exit 1
  fi
  if [ -n $hostname ]; then
    echo "    hostname: $hostname" >> /ngrok-config/ngrok.yml
  elif [ -n $subdomain ]; then
    echo "    subdomain: $subdomain" >> /ngrok-config/ngrok.yml
  fi

  echo "Starting ngrok"
fi

ngrok start --config /ngrok-config/ngrok.yml --all
