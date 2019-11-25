ARG BUILD_FROM=hassioaddons/base:5.0.2
FROM ${BUILD_FROM}

RUN set -x \
 && apk add --no-cache curl \
 && curl -Lo /ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip \
 && unzip -o /ngrok.zip -d /bin \
 && rm -f /ngrok.zip \
 && adduser -h /home/ngrok -D -u 6737 ngrok
RUN  ngrok --version

COPY --chown=ngrok ngrok.yml /home/ngrok/.ngrok2/
COPY entrypoint.sh /

USER ngrok
ENV USER=ngrok

EXPOSE 4040

CMD ["/entrypoint.sh"]