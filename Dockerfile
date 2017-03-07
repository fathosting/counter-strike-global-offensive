FROM fathosting/steamcmd:latest
MAINTAINER FAT <contact@fat.sh>

ARG APP_NAME
ARG APP_ID

ENV APP_NAME=$APP_NAME APP_ID=$APP_ID

COPY lsyncd.conf.lua /etc/lsyncd/
COPY docker-entrypoint.sh /usr/local/bin/

VOLUME ["/home/steam/backup"]
EXPOSE 27015

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["./srcds_run -game $APP_NAME"]
