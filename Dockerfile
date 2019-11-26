ARG BUILD_FROM
FROM $BUILD_FROM

RUN set -x \
 && apk add --no-cache curl \
 && if [[ "${BUILD_ARCH}" = "aarch64" ]]; then ARCH="arm64"; fi \
 && if [[ "${BUILD_ARCH}" = "amd64" ]]; then ARCH="amd64"; fi \
 && if [[ "${BUILD_ARCH}" = "armhf" ]]; then ARCH="arm"; fi \
 && if [[ "${BUILD_ARCH}" = "armv7" ]]; then ARCH="arm"; fi \
 && if [[ "${BUILD_ARCH}" = "i386" ]]; then ARCH="386"; fi \
 && curl -Lo /ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-${ARCH}.zip \
 && unzip -o /ngrok.zip -d /bin \
 && rm -f /ngrok.zip
RUN  ngrok --version

COPY run.sh /
CMD ["/run.sh"]

LABEL \
    io.hass.name="ngrok Client" \
    io.hass.description="A ngrok client for Hass.io" \
    io.hass.type="addon" \
    maintainer="Dylan Hasler <dylan@hasler.me>"