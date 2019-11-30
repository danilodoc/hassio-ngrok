ARG BUILD_FROM=homeassistant/amd64-base:3.10
FROM $BUILD_FROM

ARG BUILD_ARCH=amd64
RUN set -x \
 && apk add --no-cache \
        curl
        lua-resty-http=0.13-r0 \
        nginx-mod-http-lua=1.16.1-r1 \
        nginx=1.16.1-r1 \
    \
 && if [[ "${BUILD_ARCH}" = "aarch64" ]]; then ARCH="arm64"; fi \
 && if [[ "${BUILD_ARCH}" = "amd64" ]]; then ARCH="amd64"; fi \
 && if [[ "${BUILD_ARCH}" = "armhf" ]]; then ARCH="arm"; fi \
 && if [[ "${BUILD_ARCH}" = "armv7" ]]; then ARCH="arm"; fi \
 && if [[ "${BUILD_ARCH}" = "i386" ]]; then ARCH="386"; fi \
 && curl -Lo /ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-${ARCH}.zip \
 && unzip -o /ngrok.zip -d /bin \
 && rm -f /ngrok.zip
RUN  ngrok --version
RUN mkdir /ngrok-config
COPY run.sh /
RUN chmod +x /run.sh
CMD ["/run.sh"]

LABEL \
    io.hass.name="ngrok Client" \
    io.hass.description="A ngrok client for Hass.io" \
    io.hass.type="addon" \
    maintainer="Dylan Hasler <dylan@hasler.me>"