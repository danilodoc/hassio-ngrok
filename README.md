
# Hass.io ngrok Client

A ngrok client for Hass.io

## About

This add-on creates a ngrok tunnel over http 80 and tls 443. This is particularlly useful if you're ISP does not allow you to port-forward.
It is intented to be paired with a proxy, such as [Nginx Proxy Manager](https://github.com/hassio-addons/addon-nginx-proxy-manager).

**Note**: _ngrok could in theory man-in-the-middle your tunnels. Using a TLS tunnel may help prevent this because you can control the certificate. If you have the option to port forward, that would be recommended because there is less overhead and it is more secure. To use some features of this add-on, you need a paid ngrok account._

## How to use

1. Install the addon
2. Configure options (or don't, it will work out of the box).
3. Start the addon

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```json
{
  "NGROK_AUTH": "my_authentication_token",
  "NGROK_SUBDOMAIN": "",
  "NGROK_HOSTNAME": "*.example.com*",
  "NGROK_REGION": "us",
  "NGROK_INSPECT": false,
  "PORT_80": true,
  "PORT_443": true
}
```

### Option: `NGROK_AUTH`

Set your ngrok authentication token. This option is required if using a custom subdomain or hostname or if you want to use the PORT_443 option.

### Option: `NGROK_SUBDOMAIN`

**Note**: _This option requires you set NGROK_AUTH and have a paid account_

Specifies a custom ngrok.io subdomain to use. Check out [ngrok's documentation](https://ngrok.com/docs#http-subdomain) for more information on this option. You may specify this option OR the NGROK_HOSTNAME option. Or, you may leave both options blank to get a random subdomain assigned to you.

### Option: `NGROK_HOSTNAME`

**Note**: _This option requires you set NGROK_AUTH and have a paid account_

Specifies a custom domain name to use. The use of wildcard domains is allowed (ex. *.example.com). Check out [ngrok's documentation](https://ngrok.com/docs#http-custom-domains) for more information on this option. You may specify this option OR the NGROK_SUBDOMAIN option. Alternatively, you may leave both options blank to get a random subdomain assigned to you (you will need to open the web-ui to find what the random subdomain is). This option will always take priority over NGROK_SUBDOMAIN.

### Option: `NGROK_REGION`

Specifies where the ngrok client will connect to host its tunnels. The following options are available:

**Option** | **Location**
:---:|:---
us | United States
eu | Europe
ap | Asia/Pacific
au | Australia
sa | South America
in | India

### Option: `NGROK_INSPECT`

_true or false_

Choose whether to allow ngrok to inspect your traffic. Typically this is disabled. This option only applies to http tunnels. For more information on what this does, see [ngrok's documentation](https://ngrok.com/docs#getting-started-inspect).

### Option: `PORT_80`

_true or false_

Choose whether a tunnel should be created for port 80. This option uses a HTTP tunnel.

### Option: `PORT_443`

**Note**: _This option requires you set NGROK_AUTH and have a paid account_

_true or false_

Choose wehther a tunnel should be created for port 443. This option uses a tls tunnel. Using a tls tunnel avoids certificate errors and reduces the chances of a man-in-the-middle attack.

## Known issues
ARM is not supported (Raspberry Pi) due to a formatting error in run.sh that I have not been able to successfully track down. If I solve this, I will release an update with ARM support.
