FROM hassioaddons/base-amd64:5.0.2

RUN set -x \
 && apk add --no-cache curl \
 && curl -Lo /ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip \
 && unzip -o /ngrok.zip -d /bin \
 && rm -f /ngrok.zip \
RUN  ngrok --version

COPY run.sh /

EXPOSE 4040

CMD ["/run.sh"]

LABEL \
    io.hass.name="ngrok Client" \
    io.hass.description="A ngrok Client for Hass.io" \
    io.hass.type="addon" \
    maintainer="Dylan Hasler <dylan@hasler.me>"