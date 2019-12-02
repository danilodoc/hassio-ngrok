#!/usr/bin/env bashio
set -e
mkdir -p /ngrok-config

echo "$(bashio::config 'auth_token')"
echo "$(bashio::config 'region')"
echo "$(bashio::config 'port')"
echo "$(bashio::config 'inspect')"
echo "$(bashio::config 'subdomain')"
echo "$(bashio::config 'hostname')"
echo "$(bashio::config 'use_tls')"

if [[ -f /share/ngrok.yml ]]; then
  echo "Starting ngrok using config file found at $configFile"
  cp $configFile /ngrok-config/ngrok.yml
else
  echo "web_addr: 0.0.0.0:4040" > /ngrok-config/ngrok.yml
  if [[ "$(bashio::config 'auth_token')" != "null" ]]; then
    echo "authtoken: $(bashio::config 'auth_token')" >> /ngrok-config/ngrok.yml
  fi
  if [[ $(bashio::config 'region') != "null" ]]; then
    echo "region: $(bashio::config 'region')" >> /ngrok-config/ngrok.yml
  else
    echo "No region defined, default region is US."
  fi
  echo "tunnels:" >> /ngrok-config/ngrok.yml
  echo "  home-assistant:" >> /ngrok-config/ngrok.yml
  if [[ $(bashio::config 'use_tls') == true ]]; then
    echo "    proto: tls" >> /ngrok-config/ngrok.yml
  else 
    echo "    proto: http" >> /ngrok-config/ngrok.yml
    if [[ $(bashio::config 'inspect') != "null" ]]; then
      echo "    inspect: $(bashio::config 'inspect')" >> /ngrok-config/ngrok.yml
    fi
  fi
  if [[ $(bashio::config 'port') != "null" ]]; then
    echo "    172.30.32.2:$(bashio::config 'port')" >> /ngrok-config/ngrok.yml
  else
    echo "You must specify a port!"
    exit 1
  fi
  if [[ $(bashio::config 'hostname') != "null" ]]; then
    echo "    hostname: $(bashio::config 'hostname')" >> /ngrok-config/ngrok.yml
  elif [[ $(bashio::config 'subdomain') != "null" ]]; then
    echo "    subdomain: $(bashio::config 'subdomain')" >> /ngrok-config/ngrok.yml
  fi
  cat /ngrok-config/ngrok.yml
  echo "Starting ngrok"
fi
ngrok start --config /ngrok-config/ngrok.yml --all
