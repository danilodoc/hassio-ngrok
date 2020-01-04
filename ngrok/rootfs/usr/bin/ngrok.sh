#!/usr/bin/with-contenv bashio
set -e
mkdir -p /ngrok-config
echo "log: stdout" > /ngrok-config/ngrok.yml
port=$(bashio::addon.port 4040)
if bashio::var.has_value "${port}"; then
  echo "web_addr: 0.0.0.0:$port" >> /ngrok-config/ngrok.yml
fi
if bashio::var.has_value "$(bashio::config 'log_level')"; then
  echo "log_level: $(bashio::config 'log_level')" > /ngrok-config/ngrok.yml
fi
if bashio::var.has_value "$(bashio::config 'auth_token')"; then
  echo "authtoken: $(bashio::config 'auth_token')" >> /ngrok-config/ngrok.yml
fi
if bashio::var.has_value "$(bashio::config 'region')"; then
  echo "region: $(bashio::config 'region')" >> /ngrok-config/ngrok.yml
else
  echo "No region defined, default region is US."
fi
echo "tunnels:" >> /ngrok-config/ngrok.yml
for id in $(bashio::config "tunnels|keys"); do
  name=$(bashio::config "tunnels[${id}].name")
  echo "  $name:" >> /ngrok-config/ngrok.yml
  proto=$(bashio::config "tunnels[${id}].proto")
  if [[ $proto != "null" ]]; then
    echo "    proto: $proto" >> /ngrok-config/ngrok.yml
  fi
  addr=$(bashio::config "tunnels[${id}].addr")
  if [[ $addr != "null" ]]; then
    echo "    addr: $addr" >> /ngrok-config/ngrok.yml
  fi
  inspect=$(bashio::config "tunnels[${id}].inspect")
  if [[ $inspect != "null" ]]; then
    echo "    inspect: $inspect" >> /ngrok-config/ngrok.yml
  fi
  auth=$(bashio::config "tunnels[${id}].auth")
  if [[ $auth != "null" ]]; then
    echo "    auth: $auth" >> /ngrok-config/ngrok.yml
  fi
  host_header=$(bashio::config "tunnels[${id}].host_header")
  if [[ $host_header != "null" ]]; then
    echo "    host_header: $host_header" >> /ngrok-config/ngrok.yml
  fi
  bind_tls=$(bashio::config "tunnels[${id}].bind_tls")
  if [[ $bind_tls != "null" ]]; then
    echo "    bind_tls: $bind_tls" >> /ngrok-config/ngrok.yml
  fi
  subdomain=$(bashio::config "tunnels[${id}].subdomain")
  if [[ $subdomain != "null" ]]; then
    echo "    subdomain: $subdomain" >> /ngrok-config/ngrok.yml
  fi
  hostname=$(bashio::config "tunnels[${id}].hostname")
  if [[ $hostname != "null" ]]; then
    echo "    hostname: $hostname" >> /ngrok-config/ngrok.yml
  fi
  crt=$(bashio::config "tunnels[${id}].crt")
  if [[ $crt != "null" ]]; then
    echo "    crt: $crt" >> /ngrok-config/ngrok.yml
  fi
  key=$(bashio::config "tunnels[${id}].key")
  if [[ $key != "null" ]]; then
    echo "    key: $key" >> /ngrok-config/ngrok.yml
  fi
  client_cas=$(bashio::config "tunnels[${id}].client_cas")
  if [[ $client_cas != "null" ]]; then
    echo "    client_cas: $client_cas" >> /ngrok-config/ngrok.yml
  fi
  remote_addr=$(bashio::config "tunnels[${id}].remote_addr")
  if [[ $remote_addr != "null" ]]; then
    echo "    remote_addr: $remote_addr" >> /ngrok-config/ngrok.yml
  fi
  metadata=$(bashio::config "tunnels[${id}].metadata")
  if [[ $metadata != "null" ]]; then
    echo "    metadata: $metadata" >> /ngrok-config/ngrok.yml
  fi
done
configfile=$(cat /ngrok-config/ngrok.yml)
bashio::log.debug "\n${configfile}"
ngrok start --config /ngrok-config/ngrok.yml --all
