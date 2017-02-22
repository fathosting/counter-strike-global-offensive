FROM fathosting/steamcmd:latest
MAINTAINER FAT <contact@fat.sh>

ARG APP_NAME
ARG APP_ID

COPY lsyncd.conf.lua /etc/lsyncd/
COPY docker-entrypoint.sh /usr/local/bin/
COPY $APP_NAME /home/steam/$APP_NAME/

RUN chown steam:steam /home/steam/$APP_NAME

RUN ./steamcmd.sh \
      +login anonymous \
      +force_install_dir /home/steam/$APP_NAME \
      +app_update $APP_ID validate \
      +quit

VOLUME ["/home/steam/backup"]
EXPOSE 27015

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["./srcds_run -game $APP_NAME"]
