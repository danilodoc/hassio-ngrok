
# Hass.io ngrok Client

A ngrok client for Hass.io

## About

This add-on creates a ngrok tunnel over http and https. Some ISPs do not allow
port forwarding due to port blocking or CG-NAT. If you're able to setup a port
forward, do not use this addon.


**Note**: _ngrok could man-in-the-middle your http tunnels if they wanted.
Using a TLS tunnel will prevent this because you can control the certificate.
To use some features of this add-on, you need a paid ngrok account._

## How to use

1. Add the Github repo to your Hass.io: [https://github.com/ThePicklenat0r/hassio-addons](https://github.com/ThePicklenat0r/hassio-addons)
2. Install the addon
3. You have 3 options for configuration:
    1. Leave the default configuration and start the addon.
      _This is **not** recommended as the default configuration can expose your
      data to ngrok!_
    2. Configure the options in the addon (see descriptions for each option below).
    3. Create a custom configuration file for ngrok and save it to /share/ngrok-config
      with the name ngrok.yml. See [ngrok's documentation](https://ngrok.com/docs#config-options) for details on how to create a configuration file.
      This method overrides any options set through the addon config.
4. Start the addon

**Note**: _If you did not specify a `subdomain` or `hostname` you will need to open the web interface to get your ngrok.io url._

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```json
{
  "auth_token": "my-auth-token",
  "region": "us",
  "tunnels":
    [
      {
        "proto": "proto",
        "addr": "8123",
        "hostname": "home.example.com"
      }
    ]
}
```

### Option: `auth_token`

Set your ngrok authentication token. This option is required if using a custom
`subdomain` or `hostname` or if you want to use the `use_tls` option.

### Option: `region`

Specifies where the ngrok client will connect to host its tunnels. The following
options are available:

**Option** | **Location**
:---:|:---
us | United States
eu | Europe
ap | Asia/Pacific
au | Australia
sa | South America
in | India

### Option: `tunnels`

Define ngrok tunnels. Please read [ngrok's documentation][ngrok-tunnel-def] for
a description of each available option. All defined tunnel definition options
are available in this addon.

[ngrok-tunnel-def]: https://ngrok.com/docs#tunnel-definitions