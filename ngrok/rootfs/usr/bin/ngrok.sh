#!/usr/bin/with-contenv bashio
set -e
echo "log: stdout" > ~/.ngrok2/ngrok.yml
if bashio::var.has_value "$(bashio::addon.port 4040)"; then
  echo "web_addr: 0.0.0.0:$(bashio::addon.port 4040)" >> ~/.ngrok2/ngrok.yml
fi
if bashio::var.has_value "$(bashio::config 'log_level')"; then
  echo "log_level: $(bashio::config 'log_level')" > ~/.ngrok2/ngrok.yml
fi
if [[ "$(bashio::config 'auth_token')" != "null" ]]; then
  echo "authtoken: $(bashio::config 'auth_token')" >> ~/.ngrok2/ngrok.yml
fi
if [[ $(bashio::config 'region') != "null" ]]; then
  echo "region: $(bashio::config 'region')" >> ~/.ngrok2/ngrok.yml
else
  echo "No region defined, default region is US."
fi
echo "tunnels:" >> ~/.ngrok2/ngrok.yml
for id in $(bashio::config "tunnels|keys"); do
  echo "  $(bashio::config 'tunnels[${id}].name'):" >> ~/.ngrok2/ngrok.yml
  proto=$(bashio::config "tunnels[${id}].proto")
  if [[ $proto != "null" ]]; then
    echo "    proto: $proto" >> ~/.ngrok2/ngrok.yml
  fi
  addr=$(bashio::config "tunnels[${id}].addr")
  if [[ $addr != "null" ]]; then
    echo "    addr: $addr" >> ~/.ngrok2/ngrok.yml
  fi
  inspect=$(bashio::config "tunnels[${id}].inspect")
  if [[ $inspect != "null" ]]; then
    echo "    inspect: $inspect" >> ~/.ngrok2/ngrok.yml
  fi
  auth=$(bashio::config "tunnels[${id}].auth")
  if [[ $auth != "null" ]]; then
    echo "    auth: $auth" >> ~/.ngrok2/ngrok.yml
  fi
  host_header=$(bashio::config "tunnels[${id}].host_header")
  if [[ $host_header != "null" ]]; then
    echo "    host_header: $host_header" >> ~/.ngrok2/ngrok.yml
  fi
  bind_tls=$(bashio::config "tunnels[${id}].bind_tls")
  if [[ $bind_tls != "null" ]]; then
    echo "    bind_tls: $bind_tls" >> ~/.ngrok2/ngrok.yml
  fi
  subdomain=$(bashio::config "tunnels[${id}].subdomain")
  if [[ $subdomain != "null" ]]; then
    echo "    subdomain: $subdomain" >> ~/.ngrok2/ngrok.yml
  fi
  hostname=$(bashio::config "tunnels[${id}].hostname")
  if [[ $hostname != "null" ]]; then
    echo "    hostname: $hostname" >> ~/.ngrok2/ngrok.yml
  fi
  crt=$(bashio::config "tunnels[${id}].crt")
  if [[ $crt != "null" ]]; then
    echo "    crt: $crt" >> ~/.ngrok2/ngrok.yml
  fi
  key=$(bashio::config "tunnels[${id}].key")
  if [[ $key != "null" ]]; then
    echo "    key: $key" >> ~/.ngrok2/ngrok.yml
  fi
  client_cas=$(bashio::config "tunnels[${id}].client_cas")
  if [[ $client_cas != "null" ]]; then
    echo "    client_cas: $client_cas" >> ~/.ngrok2/ngrok.yml
  fi
  remote_addr=$(bashio::config "tunnels[${id}].remote_addr")
  if [[ $remote_addr != "null" ]]; then
    echo "    remote_addr: $remote_addr" >> ~/.ngrok2/ngrok.yml
  fi
  metadata=$(bashio::config "tunnels[${id}].metadata")
  if [[ $metadata != "null" ]]; then
    echo "    metadata: $metadata" >> ~/.ngrok2/ngrok.yml
  fi
done
ngrok start --all
