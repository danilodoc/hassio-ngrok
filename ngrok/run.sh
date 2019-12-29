#!/usr/bin/env bashio
set -e
mkdir -p /ngrok-config
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
id=0
for tunnel in $(bashio::config "tunnels|keys"); do
  echo "  tunnel-$id" >> /ngrok-config/ngrok.yml
  if [[ $(bashio::config "tunnels[${tunnel}].proto") != "null" ]]; then
    echo "    proto: $(bashio::config 'tunnels[${tunnel}].proto')" >> /ngrok-config/ngrok.yml
  fi
  if [[ $(bashio::config "tunnels[${tunnel}].addr") != "null" ]]; then
    echo "    addr: $(bashio::config 'tunnels[${tunnel}].addr')" >> /ngrok-config/ngrok.yml
  fi
  if [[ $(bashio::config "tunnels[${tunnel}].inspect") != "null" ]]; then
    echo "    inspect: $(bashio::config 'tunnels[${tunnel}].inspect')" >> /ngrok-config/ngrok.yml
  fi
  if [[ $(bashio::config "tunnels[${tunnel}].auth") != "null" ]]; then
    echo "    auth: $(bashio::config 'tunnels[${tunnel}].auth')" >> /ngrok-config/ngrok.yml
  fi
  if [[ $(bashio::config "tunnels[${tunnel}].host_header") != "null" ]]; then
    echo "    host_header: $(bashio::config 'tunnels[${tunnel}].host_header')" >> /ngrok-config/ngrok.yml
  fi
  if [[ $(bashio::config "tunnels[${tunnel}].bind_tls") != "null" ]]; then
    echo "    bind_tls: $(bashio::config 'tunnels[${tunnel}].bind_tls')" >> /ngrok-config/ngrok.yml
  fi
  if [[ $(bashio::config "tunnels[${tunnel}].subdomain") != "null" ]]; then
    echo "    subdomain: $(bashio::config 'tunnels[${tunnel}].subdomain')" >> /ngrok-config/ngrok.yml
  fi
  if [[ $(bashio::config "tunnels[${tunnel}].hostname") != "null" ]]; then
    echo "    hostname: $(bashio::config 'tunnels[${tunnel}].hostname')" >> /ngrok-config/ngrok.yml
  fi
  if [[ $(bashio::config "tunnels[${tunnel}].crt") != "null" ]]; then
    echo "    crt: $(bashio::config 'tunnels[${tunnel}].crt')" >> /ngrok-config/ngrok.yml
  fi
  if [[ $(bashio::config "tunnels[${tunnel}].key") != "null" ]]; then
    echo "    key: $(bashio::config 'tunnels[${tunnel}].key')" >> /ngrok-config/ngrok.yml
  fi
  if [[ $(bashio::config "tunnels[${tunnel}].client_cas") != "null" ]]; then
    echo "    client_cas: $(bashio::config 'tunnels[${tunnel}].client_cas')" >> /ngrok-config/ngrok.yml
  fi
  if [[ $(bashio::config "tunnels[${tunnel}].remote_addr") != "null" ]]; then
    echo "    remote_addr: $(bashio::config 'tunnels[${tunnel}].remote_addr')" >> /ngrok-config/ngrok.yml
  fi
  if [[ $(bashio::config "tunnels[${tunnel}].metadata") != "null" ]]; then
    echo "    metadata: $(bashio::config 'tunnels[${tunnel}].metadata')" >> /ngrok-config/ngrok.yml
  fi
  $id+1
done
echo "Starting ngrok..."
ngrok start --config /ngrok-config/ngrok.yml --all
